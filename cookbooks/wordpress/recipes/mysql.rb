#
# Cookbook:: wordpress
# Recipe:: mysql
#
# Copyright:: 2017, The Authors, All Rights Reserved.
MYSQL_CREDS = {
  root: {
    pwd: 'incredibly_secure_password'
  },
  wordpress: {
    db: 'wordpress',
    user: 'wordpressuser',
    pwd: 'another_ultrasecure_password'
  }
}.freeze

bash 'update_apt-get' do
  code 'apt-get update'
end

bash 'set_insecure_mysql_password' do
  code <<-BASH
    echo 'mysql-server mysql-server/root_password password #{MYSQL_CREDS[:root][:pwd]}' | sudo debconf-set-selections
    echo 'mysql-server mysql-server/root_password_again select #{MYSQL_CREDS[:root][:pwd]}' | debconf-set-selections
  BASH
end

package 'mysql-server'

service 'mysql' do
  action [:start, :enable]
end

bash 'setup_wordpress_db' do
  code <<-BASH
    mysql -u root --password='#{MYSQL_CREDS[:root][:pwd]}' -e "CREATE DATABASE #{MYSQL_CREDS[:wordpress][:db]} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mysql -u root --password='#{MYSQL_CREDS[:root][:pwd]}' -e "GRANT ALL ON #{MYSQL_CREDS[:wordpress][:db]}.* TO '#{MYSQL_CREDS[:wordpress][:user]}'@'localhost' IDENTIFIED BY '#{MYSQL_CREDS[:wordpress][:pwd]}';"
    mysql -u root --password='#{MYSQL_CREDS[:root][:pwd]}' -e "FLUSH PRIVILEGES;"
  BASH
end
