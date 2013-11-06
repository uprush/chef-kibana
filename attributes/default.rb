default['kibana']['repo'] = "git://github.com/elasticsearch/kibana"
default['kibana']['branch'] = "master"
default['kibana']['webserver'] = "nginx"
default['kibana']['installdir'] = "/opt/kibana"
default['kibana']['config_dir'] = "/etc/kibana"
default['kibana']['es_server'] = "localhost"
default['kibana']['es_port'] = "9200"
default['kibana']['es_role'] = "elasticsearch_server"
default['kibana']['user'] = ''
default['kibana']['config_template'] = 'config.js.erb'
default['kibana']['config_cookbook'] = 'kibana'
default['kibana']['webserver_hostname'] = node.name
default['kibana']['webserver_aliases'] = [node.ipaddress]
default['kibana']['webserver_listen'] = node.ipaddress
default['kibana']['webserver_port'] = 80

default['kibana']['version'] = "latest"
default['kibana']['download_url'] = "http://download.elasticsearch.org/kibana/kibana"
