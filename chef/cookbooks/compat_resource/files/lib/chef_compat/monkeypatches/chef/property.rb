# 12.9 introduced a new optional parameter to `get()` to avoid a nil-set warning.
# We need to mimick it here.
if Chef::VERSION.to_f >= 12.5 && Chef::VERSION.to_f <= 12.8
  require 'chef/property'
  class Chef
    class Property
      # 12.9 introduced a new optional parameter to `get()` to avoid a nil-set warning.
      # When their method gets called with 2 args, we need to ignore and call with 1.
      alias_method :_original_get, :get
      def get(resource, *args)
        _original_get(resource)
      end
    end
  end
end
