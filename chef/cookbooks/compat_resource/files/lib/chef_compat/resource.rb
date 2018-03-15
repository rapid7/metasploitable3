require 'chef_compat/monkeypatches'
require 'chef_compat/copied_from_chef/chef/resource'

# We do NOT want action defined if chefspec is engaged
if Chef::Provider::InlineResources::ClassMethods.instance_method(:action).source_location[0] =~ /chefspec/
  ChefCompat::CopiedFromChef::Chef::Provider::InlineResources::ClassMethods.instance_eval do
    remove_method(:action)
  end
end

module ChefCompat
  class Resource < ChefCompat::CopiedFromChef::Chef::Resource
    def initialize(*args, &block)
      super
      # @resource_name is used in earlier Chef versions
      @resource_name = self.class.resource_name
    end
    # Things we'll need to define ourselves:
    # 1. provider
    # 2. resource_name

    def provider(*args, &block)
      super || self.class.action_class
    end
    def provider=(arg)
      provider(arg)
    end

    if !respond_to?(:resource_name)
      def self.resource_name(name=Chef::NOT_PASSED)
        # Setter
        if name != Chef::NOT_PASSED
  #        remove_canonical_dsl

          # Set the resource_name and call provides
          if name
            name = name.to_sym
            # If our class is not already providing this name, provide it.
            # Commented out: use of resource_name and provides will need to be
            # mutually exclusive in this world, generally.
            # if !Chef::ResourceResolver.includes_handler?(name, self)
              provides name#, canonical: true
            # end
            @resource_name = name
          else
            @resource_name = nil
          end
        end
        @resource_name
      end
      def self.resource_name=(name)
        resource_name(name)
      end
    end
  end
end
