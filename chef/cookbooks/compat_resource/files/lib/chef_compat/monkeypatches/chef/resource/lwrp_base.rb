require 'chef_compat/resource/lwrp_base'
require 'chef/resource/lwrp_base'

module ChefCompat
  module Monkeypatches
    #
    # NOTE: LOTS OF METAPROGRAMMING HERE. NOT FOR FAINT OF HEART.
    #

    # Add an empty module to Class so we can temporarily override it in build_from_file
    module Class
    end
    class<<::Class
      prepend(ChefCompat::Monkeypatches::Class)
    end

    module Chef
      module Resource
        module LWRPBase
          def build_from_file(cookbook_name, filename, run_context)
            # If the cookbook this LWRP is from depends on compat_resource, fix its LWRPs up real good
            if run_context.cookbook_collection[cookbook_name].metadata.dependencies.has_key?('compat_resource')
              # All cookbooks do Class.new(Chef::Resource::LWRPBase). Change Class.new
              # temporarily to translate Chef::Resource::LWRPBase to ChefCompat::Resource
              ChefCompat::Monkeypatches::Class.module_eval do
                def new(*args, &block)
                  # Trick it! Use ChefCompat::Resource instead of Chef::Resource::LWRPBase
                  if args == [ ::Chef::Resource::LWRPBase ]
                    ChefCompat::Monkeypatches::Class.module_eval do
                      remove_method(:new) if method_defined?(:new)
                    end
                    args = [ ChefCompat::Resource::LWRPBase ]
                  end
                  super(*args, &block)
                end
              end

              begin

                # Call the actual build_from_file
                super

              ensure
                class<<ChefCompat::Monkeypatches::Class
                  remove_method(:new) if method_defined?(:new)
                end
              end
            else
              # Call the actual build_from_file
              super
            end
          end
        end
        class <<::Chef::Resource::LWRPBase
          prepend(LWRPBase)
        end
      end
    end
  end
end
