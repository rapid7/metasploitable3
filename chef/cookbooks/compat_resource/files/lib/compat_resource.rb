require "chef/version"

if Gem::Requirement.new(">= 12.0").satisfied_by?(Gem::Version.new(Chef::VERSION))

  require 'chef_compat/resource'
  require 'chef_compat/property'
  require 'chef_compat/mixin/properties'

  resources_dir = File.expand_path("chef_compat/copied_from_chef/chef/resource", File.dirname(__FILE__))
  providers_dir = File.expand_path("chef_compat/copied_from_chef/chef/provider", File.dirname(__FILE__))
  Dir["#{resources_dir}/*.rb"].each {|file| require file }
  Dir["#{providers_dir}/*.rb"].each {|file| require file }
else

  class Chef
    class Resource
      def self.property(args, &block)
        raise_chef_11_error
      end

      def self.resource_name(args, &block)
        raise_chef_11_error
      end

      def self.action(args, &block)
        raise_chef_11_error
      end

      def self.raise_chef_11_error
        raise "This resource is written with Chef 12.5 custom resources, and requires at least Chef 12.0 used with the compat_resource cookbook, it will not work with Chef 11.x clients, and those users must pin their cookbooks to older versions or upgrade."
      end
    end
  end

end
