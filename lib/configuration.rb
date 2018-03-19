require_relative 'chef'

class Configuration
  attr_accessor :credentials, :chefs

  def to_s
    attributes.inspect
  end

  def chefs=(value)
    chef_arr = []
    value.each do |chef_value|
      chef_arr << Chef.new(chef_value)
    end
    @chefs = chef_arr
  end

  def attributes
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end