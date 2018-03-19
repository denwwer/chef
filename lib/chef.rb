require 'ostruct'

class Chef
  attr_accessor :name, :assigns

  def initialize(chef_setting)
    if chef_setting.class == String
      self.name = chef_setting
      self.assigns = nil
    else
      self.name = chef_setting.keys.first
      self.assigns = OpenStruct.new chef_setting.values.first
    end
  end
end