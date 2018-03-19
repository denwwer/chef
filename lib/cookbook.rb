require 'yaml'
require 'fileutils'
require 'erb'

require_relative 'configuration'
require_relative 'erb_interpreter'

class Cookbook
  attr_accessor :name, :cookbook_folder, :environment

  def initialize(config_file:, environment:, name: Time.now.strftime('%Y%m%d%H%M%S'))
    self.name = name
    self.environment = environment.to_s
    self.cookbook_folder = "cookbooks/#{name}"

    configure do |config|
      YAML.load(config_file).each do |key, value|
        raise "Invalid configuration key '#{key}'" unless config.respond_to? key
        config.public_send "#{key}=", value
      end
    end

    # puts config
    setup
    # upload
    # remote_run
  end

  # Create new upload directory inside 'cookbooks', set up needed files
  def setup
    FileUtils::mkdir_p "#{cookbook_folder}/chef"
    File.open("#{cookbook_folder}/setup.sh", 'w') do |f|
      f.write ERB.new(File.read('lib/setup.sh.erb')).result(binding)
    end

    FileUtils.copy_entry 'lib/ext', "#{cookbook_folder}/ext"

    # TODO
    FileUtils.cp config.credentials[environment.to_s]['ssh_pub_key'], cookbook_folder

    config.chefs.each {|chef| setup_chef chef}
  end

  def upload
    puts 'Upload chef'
    system "rsync -avz -e 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' #{cookbook_folder} #{host_with_user}:#{credentials['remote_chef_path']}"
  end

  def remote_run
    system "ssh -t #{host_with_user} 'cd #{credentials['remote_chef_path']}/#{name} && sudo chmod 777 setup.sh && ./setup.sh' | tee -a logs/chef.log"
  end

  def config
    @config ||= Configuration.new
  end

  def configure
    yield config
  end

  private

  def setup_chef(chef)
    chef_folder = "#{cookbook_folder}/chef/#{chef.name}"

    FileUtils.copy_entry "chef/#{chef.name}", chef_folder

    Dir.glob("#{chef_folder}/*.erb") do |erb_file|
      File.open(erb_file.sub('.erb', ''), 'w') do |f|
        f.write ErbInterpreter.render_from_hash(File.read(erb_file), chef.assigns)
      end
      FileUtils.rm erb_file
    end

    File.open("#{cookbook_folder}/setup.sh", 'a') do |f|
      f.puts "\n. ./chef/#{chef.name}/chef.sh"
      f.puts "chef_#{chef.name}"
    end
  end

  def credentials
    config.credentials[environment]
  end

  def host_with_user
    credentials['remote_user'] + '@' + credentials['remote_host']
  end
end

