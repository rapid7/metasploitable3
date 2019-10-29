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
      g.system true if new_resource.name == 'mysql'
      resource_collection.insert g

      user new_resource.owner do
        gid new_resource.owner
        system true if new_resource.name == 'mysql'
        action :create
      end

      directory new_resource.include_dir do
        owner new_resource.owner
        group new_resource.group
        mode '0750'
        recursive true
        action :create
      end

      template "#{new_resource.include_dir}/#{new_resource.config_name}.cnf" do
        owner new_resource.owner
        group new_resource.group
        mode '0640'
        variables(new_resource.variables)
        source new_resource.source
        cookbook new_resource.cookbook
        action :create
      end
    end

    action :delete do
      file "#{new_resource.include_dir}/#{new_resource.config_name}.cnf" do
        action :delete
      end
    end
  end
end
