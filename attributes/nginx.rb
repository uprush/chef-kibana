default['kibana']['nginx']['template'] = 'kibana-nginx.conf.erb'
default['kibana']['nginx']['template_cookbook'] = 'kibana'
default['kibana']['nginx']['enable_default_site'] = false
default['kibana']['nginx']['user'] = 'www-data'
default['kibana']['nginx']['users'] = []
default['kibana']['nginx']['passwords_dir'] = "/etc/kibana"
default['kibana']['nginx']['passwords_file'] = "#{node['kibana']['nginx']['passwords_dir']}/passwords"
