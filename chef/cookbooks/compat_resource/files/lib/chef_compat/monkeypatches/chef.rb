class Chef
  NOT_PASSED = Object.new if !defined?(NOT_PASSED)
  # Earlier versions of Chef didn't have this message
  module ChefCompatDeprecation
    def log_deprecation(message, location=nil)
      if !location
        # Pick the first caller that is *not* part of the Chef or ChefCompat gem,
        # that's the thing the user wrote.
        chef_compat_gem_path = File.expand_path("../../..", __FILE__)
        chef_gem_path = File.expand_path("../..",::Chef::Resource.instance_method(:initialize).source_location[0])
        caller(0..10).each do |c|
          if !c.start_with?(chef_gem_path) && !c.start_with?(chef_compat_gem_path)
            location = c
            break
          end
        end
      end

      begin
        super
        # Bleagh. `super_method` doesn't exist on older rubies and I haven't
        # figured out a way to check for its existence otherwise.
      rescue NoMethodError
        Chef::Log.warn(message)
      end
    end
  end

  class<<self
    prepend ChefCompatDeprecation
  end

end
