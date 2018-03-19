require_relative 'lib/cookbook'

Cookbook.new(
  config_file: File.open('config.yml'),
  environment: :production
)