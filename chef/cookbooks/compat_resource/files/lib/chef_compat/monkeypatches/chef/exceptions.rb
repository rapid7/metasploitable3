require 'chef/exceptions'

class Chef
  class Exceptions
    # Used in Resource::ActionClass#load_current_resource to denote that
    # the resource doesn't actually exist (for example, the file does not exist)
    class CurrentValueDoesNotExist < RuntimeError; end unless defined?(CurrentValueDoesNotExist)
    class CannotValidateStaticallyError < RuntimeError; end unless defined?(CannotValidateStaticallyError)
  end
end
