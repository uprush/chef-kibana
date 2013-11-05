#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2013, John E. Vincent
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

include_recipe "ark"

unless Chef::Config[:solo]
  es_server_results = search(:node, "roles:#{node['kibana']['es_role']} AND chef_environment:#{node.chef_environment}")
  unless es_server_results.empty?
    node.set['kibana']['es_server'] = es_server_results[0]['ipaddress']
  end
end

if node['kibana']['user'].empty?
  webserver = node['kibana']['webserver']
  kibana_user = "#{node[webserver]['user']}"
else
  kibana_user = node['kibana']['user']
end

directory node['kibana']['installdir'] do
  owner kibana_user
  mode "0755"
end

ins_dir = node['kibana']['installdir']
kibana_version = node['kibana']['version']

bash "remove the kibana install directory" do
  user    'root'
  code    "rm -rf  #{ins_dir}/kibana-#{kibana_version}"

  only_if "test -d #{ins_dir}/kibana-#{kibana_version}"
end

bash "remove the kibana current symbolic link" do
  user    'root'
  code    "rm -f  #{ins_dir}/current"

  only_if "test -L #{ins_dir}/current"
end

# Download, extract, symlink the elasticsearch libraries and binaries
#
ark_prefix_root = ins_dir || node.ark[:prefix_root]
ark_prefix_home = ins_dir || node.ark[:prefix_home]

ark "kibana" do
  url   "#{node['kibana']['download_url']}/kibana-#{kibana_version}.zip"
  owner kibana_user
  group kibana_user
  version kibana_version
  prefix_root   ark_prefix_root
  prefix_home   ark_prefix_home

  not_if do
    link   = "#{ins_dir}/current"
    target = "#{ins_dir}/kibana-#{kibana_version}"

    ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
  end
end

bash "change kibana link name" do
  cwd ins_dir
  user kibana_user
  code "mv kibana current"
  only_if ::File.symlink?("kibana")
end

template "#{node['kibana']['installdir']}/current/config.js" do
  source node['kibana']['config_template']
  cookbook node['kibana']['config_cookbook']
  mode "0750"
  user kibana_user
end

include_recipe "kibana::#{node['kibana']['webserver']}"
