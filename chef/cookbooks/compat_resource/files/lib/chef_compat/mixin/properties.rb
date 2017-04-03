require 'chef_compat/monkeypatches'
require 'chef_compat/copied_from_chef/chef/mixin/properties'

module ChefCompat
  module Mixin
    Properties = ChefCompat::CopiedFromChef::Chef::Mixin::Properties
  end
end
