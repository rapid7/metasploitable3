require 'chef/recipe'
require 'chef_compat/recipe'

class Chef::Recipe
  # If the cookbook depends on compat_resource, create a ChefCompat::Recipe object
  # instead of Chef::Recipe, for the extra goodies.
  def self.new(cookbook_name, recipe_name, run_context)
    if run_context &&
        cookbook_name &&
        recipe_name &&
        run_context.cookbook_collection &&
        run_context.cookbook_collection[cookbook_name] &&
        run_context.cookbook_collection[cookbook_name].metadata.dependencies.has_key?('compat_resource') &&
        self != ::ChefCompat::Recipe
      ::ChefCompat::Recipe.new(cookbook_name, recipe_name, run_context)
    else
      super
    end
  end
end
