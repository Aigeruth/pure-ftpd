class Chef
  class Recipe
    def backends
      @backends ||= node['pure-ftpd']['auth'].keys
    end

    def selected_backend
      node['pure-ftpd']['backend']
    end

    def disabled_backends
      backends - [selected_backend]
    end

    def database_backends
      @database_backends ||= %w(ldap mysql postgresql puredb)
    end

    def standard_backends
      @standard_backends ||= %w(pam unix)
    end

    def database_backend?
      database_backends.include? selected_backend
    end

    def standard_backend?
      standard_backends.include? selected_backend
    end

    def enabled_options
      node['pure-ftpd']['options']['enabled'].map { |k| [k, 'yes'] }
    end

    def disabled_options
      node['pure-ftpd']['options']['disabled'].map { |k| [k, 'no'] }
    end

    def options_list
      node['pure-ftpd']['options'].dup.reject { |k, _| %w(enabled disabled).include? k }.to_a
    end

    def options
      options_list + enabled_options + disabled_options
    end

    def link_authentication_backend_configuration(backend, link_action)
      dir = node['pure-ftpd']['auth_config_dir']
      backend_priority = node['pure-ftpd']['auth'][backend]['priority']
      backend_name = node['pure-ftpd']['auth'][backend]['name']
      link "#{backend_priority}#{backend_name}" do
        target_file "#{dir}/#{backend_priority}#{backend_name}"
        to "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][backend]['filename']}"
        action link_action
      end
    end
  end
end
