#
# Cookbook:: wordpress
# Recipe:: lamp_server
#
# Copyright:: 2017, The Authors, All Rights Reserved.
bash 'update_apt-get' do
  code 'apt-get update'
end

package 'lamp-server^'
