require 'chef/provider'
require 'chef/provider/lwrp_base'

class Chef::Provider
  if !defined?(InlineResources)
    InlineResources = Chef::Provider::LWRPBase::InlineResources
  end
  module InlineResources
    require 'chef/dsl/recipe'
    require 'chef/dsl/platform_introspection'
    require 'chef/dsl/data_query'
    require 'chef/dsl/include_recipe'
    include Chef::DSL::Recipe
    include Chef::DSL::PlatformIntrospection
    include Chef::DSL::DataQuery
    include Chef::DSL::IncludeRecipe

    unless Chef::Provider::InlineResources::ClassMethods.instance_method(:action).source_location[0] =~ /chefspec/
      # Don't override action if chefspec is doing its thing
      module ::ChefCompat
        module Monkeypatches
          module InlineResources
            module ClassMethods
              def action(name, &block)
                super(name) { send("compile_action_#{name}") }
                # We put the action in its own method so that super() works.
                define_method("compile_action_#{name}", &block)
              end
            end
          end
        end
      end
      module ClassMethods
        prepend ChefCompat::Monkeypatches::InlineResources::ClassMethods
      end
    end
  end
end


class Chef
  class Provider
    class LWRPBase < Provider
      if defined?(InlineResources)
        module InlineResources
          # since we upgrade the Chef::Runner and Chef::RunContext globally to >= 12.14 style classes, we need to also
          # fix the use_inline_resources LWRPBase wrapper that creates a sub-resource collection with the ugpraded code
          # from the Chef::Provider subclasses that do similar things in post-12.5 chef.
          def recipe_eval_with_update_check(&block)
            old_run_context = run_context
            @run_context = run_context.create_child
            return_value = instance_eval(&block)
            Chef::Runner.new(run_context).converge
            return_value
          ensure
            if run_context.resource_collection.any? { |r| r.updated? }
              new_resource.updated_by_last_action(true)
            end
            @run_context = old_run_context
          end
        end
      end
    end
  end
end
