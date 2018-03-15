#
# Author:: Adam Jacob (<adam@chef.io>)
# Author:: Christopher Walters (<cw@chef.io>)
# Copyright:: Copyright 2008-2016, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "chef/resource_collection/resource_set"
require "chef/resource_collection/resource_list"
require "chef/resource_collection"
require "chef/exceptions"

module ChefCompat
  module Monkeypatches
    module Chef
      module ResourceCollection
        module RecursiveNotificationLookup
          #
          # Copied verbatim from Chef 12.10.24
          #
          attr_accessor :run_context

          def initialize(run_context = nil)
            super()
            @run_context = run_context
          end

          def lookup_local(key)
            resource_set.lookup(key)
          end

          def find_local(*args)
            resource_set.find(*args)
          end

          def lookup(key)
            if run_context.nil?
              lookup_local(key)
            else
              lookup_recursive(run_context, key)
            end
          end

          def find(*args)
            if run_context.nil?
              find_local(*args)
            else
              find_recursive(run_context, *args)
            end
          end

          private

          def lookup_recursive(rc, key)
            rc.resource_collection.send(:resource_set).lookup(key)
          rescue ::Chef::Exceptions::ResourceNotFound
            raise if !rc.respond_to?(:parent_run_context) || rc.parent_run_context.nil?
            lookup_recursive(rc.parent_run_context, key)
          end

          def find_recursive(rc, *args)
            rc.resource_collection.send(:resource_set).find(*args)
          rescue ::Chef::Exceptions::ResourceNotFound
            raise if !rc.respond_to?(:parent_run_context) || rc.parent_run_context.nil?
            find_recursive(rc.parent_run_context, *args)
          end
        end

        module DeleteResources
          #
          # Copied verbatim from Chef 12.10.24
          #
          def delete(key)
            resource_list.delete(key)
            resource_set.delete(key)
          end
        end
      end
    end
  end
end


class Chef::ResourceCollection
  unless method_defined?(:lookup_local)
    prepend ChefCompat::Monkeypatches::Chef::ResourceCollection::RecursiveNotificationLookup
  end
  unless method_defined?(:delete)
    prepend ChefCompat::Monkeypatches::Chef::ResourceCollection::DeleteResources
  end
end
