module MysqlCookbook
  class MysqlConfig < MysqlBase
    resource_name :mysql_config

    property :config_name, String, name_property: true, desired_state: false
    property :cookbook, String, desired_state: false
    property :group, String, default: 'mysql', desired_state: false
    property :instance, String, default: 'default', desired_state: false
    property :owner, String, default: 'mysql', desired_state: false
    property :source, String, desired_state: false
    property :variables, [Hash], desired_state: false
    property :version, String, default: lazy { default_major_version }, desired_state: false

    require_relative 'helpers'
    include MysqlCookbook::HelpersBase

    provides :mysql_config

    action :create do
      # hax because group property
      g = Chef::Resource::Group.new(new_resource.group, run_context)
      g.system true if name == 'mysql'
      resource_collection.insert g

      user owner do
        gid owner
        system true if name == 'mysql'
        action :create
      end

      directory include_dir do
        owner new_resource.owner
        group new_resource.group
        mode '0750'
        recursive true
        action :create
      end

      template "#{include_dir}/#{config_name}.cnf" do
        owner new_resource.owner
        group new_resource.group
        mode '0640'
        variables(new_resource.variables)
        source new_resource.source
        cookbook cookbook
        action :create
      end
    end

    action :delete do
      file "#{include_dir}/#{config_name}.cnf" do
        action :delete
      end
    end
  end
end
