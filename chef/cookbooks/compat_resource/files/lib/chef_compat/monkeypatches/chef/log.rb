require 'chef/log'

# for now we have to patch this in everything
class Chef
  class Log
    def self.caller_location
      # Pick the first caller that is *not* part of the Chef gem, that's the
      # thing the user wrote.
      compat_resource_path = File.expand_path("../../../../..", __FILE__)
      chef_gem_path = Gem.loaded_specs['chef'].full_gem_path
      caller(0..20).find { |c| !c.start_with?(compat_resource_path) && !c.start_with?(chef_gem_path) }
    end
  end
end

if Gem::Requirement.new('< 12.13.37').satisfied_by?(Gem::Version.new(Chef::VERSION))

  # FIXME: why does this not match the implementation in Chef itself?
  class Chef
    class Log
      module ChefCompatDeprecation
        def deprecation(message, location=nil)
          Chef.log_deprecation(message, location)
        end
      end
      extend ChefCompatDeprecation
    end
  end

end
