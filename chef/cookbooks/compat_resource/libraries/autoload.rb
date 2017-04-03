unless Gem::Requirement.new(">= 12.0").satisfied_by?(Gem::Version.new(Chef::VERSION))
  raise "This resource is written with Chef 12.5 custom resources, and requires at least Chef 12.0 used with the compat_resource cookbook, it will not work with Chef 11.x clients, and those users must pin their cookbooks to older versions or upgrade."
end

# If users are on old verisons of ChefDK which activates an (old) gem via cheffish before this cookbook loads, then
# we just try to monkeypatch over the top of a monkeypatch.  Its possible that we have checks in this cookbook which
# will defeat that purpose and fail to monkeypatch on top of monkeypatches -- in which case those checks should be
# removed -- this cookbook needs to win when it gets into a fight with the old gem versions.
if Gem.loaded_specs["compat_resource"]
  Chef.log_deprecation "using compat_resource as a gem is deprecated;  please update cheffish and chef-provisioning gems (or use the latest Chef/ChefDK packages) or else manually pin your compat_resource cookbook version to the same version as the gem you are using to remove this warning"
end

# we want to not pollute the libpath with our files until after we've done the version check
require_relative '../files/lib/chef_upstream_version'

# on any chef client later than the one we were based off of we just turn into a no-op
if Gem::Requirement.new("< #{ChefCompat::CHEF_UPSTREAM_VERSION}").satisfied_by?(Gem::Version.new(Chef::VERSION))
  Chef::Log.debug "loading compat_resource based on chef-version #{ChefCompat::CHEF_UPSTREAM_VERSION} over chef version #{Gem::Version.new(Chef::VERSION)}"
  $LOAD_PATH.unshift(File.expand_path("../files/lib", File.dirname(__FILE__)))
  require 'compat_resource'
else
  Chef::Log.debug "NOT LOADING compat_resource based on chef-version #{ChefCompat::CHEF_UPSTREAM_VERSION} over chef version #{Gem::Version.new(Chef::VERSION)}"
  unless defined?(ChefCompat::Resource) && defined?(ChefCompat::Mixin::Properties)
    module ChefCompat
      Resource = Chef::Resource
      module Mixin
        Properties = Chef::Mixin::Properties
      end
    end
  end
end
