class Chef
  class RunContext
    class ChildRunContext < RunContext
      # magic that lets us re-parse the ChildRunContext without erroring due to
      # cheffish and chef-provisioning hooks having been loaded (on old versions of
      # chef-client without the lazy hooks for those gems)
      @__skip_method_checking = true
    end
  end
end

# fix to quiet constant redefined warnings
if defined?(Chef::RunContext::ChildRunContext::CHILD_STATE)
  Chef::RunContext::ChildRunContext.send(:remove_const, :CHILD_STATE)
end

require 'chef_compat/monkeypatches/chef'
require 'chef_compat/monkeypatches/chef/exceptions'
require 'chef_compat/monkeypatches/chef/log'
require 'chef_compat/monkeypatches/chef/node'
require 'chef_compat/monkeypatches/chef/mixin/params_validate'
require 'chef_compat/monkeypatches/chef/property'
require 'chef_compat/monkeypatches/chef/provider'
require 'chef_compat/monkeypatches/chef/recipe'  # copied from chef
require 'chef_compat/monkeypatches/chef/recipe_hook'
require 'chef_compat/monkeypatches/chef/resource'
require 'chef_compat/monkeypatches/chef/resource_builder'
require 'chef_compat/monkeypatches/chef/resource/lwrp_base'
require 'chef_compat/monkeypatches/chef/resource_collection'
require 'chef_compat/monkeypatches/chef/resource_collection/resource_list'
require 'chef_compat/monkeypatches/chef/resource_collection/resource_set'
require 'chef_compat/monkeypatches/chef/run_context'  # copied from chef
require 'chef_compat/monkeypatches/chef/runner'  # copied from chef

# fix for Chef::RunContext instance that has already been created
ObjectSpace.each_object(Chef::RunContext) do |run_context|
  run_context.node.run_context = run_context
  run_context.instance_variable_set(:@loaded_recipes_hash, {})
  run_context.instance_variable_set(:@loaded_attributes_hash, {})
  run_context.initialize_child_state
end
