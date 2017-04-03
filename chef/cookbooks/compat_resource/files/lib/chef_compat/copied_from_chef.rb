module ChefCompat
  module CopiedFromChef
    def self.extend_chef_module(chef_module, target)
      target.instance_eval do
        include chef_module
        @chef_module = chef_module
        def self.method_missing(name, *args, &block)
          @chef_module.send(name, *args, &block)
        end
        def self.const_missing(name)
          @chef_module.const_get(name)
        end
      end
    end

    # This patch to CopiedFromChef's ActionClass is necessary for the include to work
    require 'chef/resource'
    class Chef < ::Chef
      class Resource < ::Chef::Resource
        module ActionClass
          def self.use_inline_resources
          end
          def self.include_resource_dsl(include_resource_dsl)
          end
        end
      end
    end
  end
end
