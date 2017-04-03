if Chef::VERSION.to_f >= 12.5 && Chef::VERSION.to_f <= 12.8
  require 'chef/mixin/params_validate'
  class Chef
    module Mixin
      module ParamsValidate
        class SetOrReturnProperty < Chef::Property
          # 12.9 introduced a new optional parameter to `get()` to avoid a nil-set warning.
          # When their method gets called with 2 args, we need to ignore and call with 1.
          alias_method :_original_get2, :get
          def get(resource, *args)
            _original_get2(resource)
          end
        end
      end
    end
  end
end
