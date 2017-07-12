require 'chef/recipe'
require 'chef_compat/copied_from_chef/chef/dsl/recipe'

module ChefCompat
  class Recipe < Chef::Recipe
    include ChefCompat::CopiedFromChef::Chef::DSL::Recipe::FullDSL
  end
end
