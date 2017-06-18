# # encoding: utf-8

# Inspec test for recipe wordpress::mysql

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
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

describe package('mysql-server') do
  it { should be_installed }
end

describe service('mysql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

sql = mysql_session("#{MYSQL_CREDS[:wordpress][:user]}", "#{MYSQL_CREDS[:wordpress][:pwd]}")
describe sql.query("show databases like \'wordpress\';") do
  its('stdout') { should match(/wordpress/) }
end
