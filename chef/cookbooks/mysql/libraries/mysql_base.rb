module MysqlCookbook
  class MysqlBase < Chef::Resource
    require_relative 'helpers'

    # All resources are composites
    def whyrun_supported?
      true
    end

    ################
    # Type Constants
    ################

    Boolean = property_type(
      is: [true, false],
      default: false
    ) unless defined?(Boolean)

    ###################
    # Common Properties
    ###################
    property :run_group, String, default: 'mysql', desired_state: false
    property :run_user, String, default: 'mysql', desired_state: false
    property :version, String, default: lazy { default_major_version }, desired_state: false
    property :include_dir, String, default: lazy { default_include_dir }, desired_state: false
    property :major_version, String, default: lazy { major_from_full(version) }, desired_state: false

    declare_action_class
  end
end
