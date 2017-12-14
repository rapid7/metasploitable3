require 'chef_compat/resource'
require 'chef_compat/copied_from_chef/chef/resource'
require 'chef/mixin/convert_to_class_name'
require 'chef/mixin/from_file'

module ChefCompat
  class Resource < ChefCompat::CopiedFromChef::Chef::Resource
    class LWRPBase < ChefCompat::Resource
      class<<self

        include Chef::Mixin::ConvertToClassName
        include Chef::Mixin::FromFile

        alias :attribute :property

        # Adds +action_names+ to the list of valid actions for this resource.
        # Does not include superclass's action list when appending.
        def actions(*action_names)
          action_names = action_names.flatten
          if !action_names.empty? && !@allowed_actions
            self.allowed_actions = ([ :nothing ] + action_names).uniq
          else
            allowed_actions(*action_names)
          end
        end
        alias :actions= :allowed_actions=

        # @deprecated
        def valid_actions(*args)
          Chef::Log.warn("`valid_actions' is deprecated, please use allowed_actions `instead'!")
          allowed_actions(*args)
        end

        # Set the run context on the class. Used to provide access to the node
        # during class definition.
        attr_accessor :run_context

        def node
          run_context ? run_context.node : nil
        end
      end
    end
  end
end
