#
# Default org, user, aws region
# These should be the only things you need to change, but better to
# overide environment than edit here in general
#
organization  = ENV['CHEF_ORGANIZATION'] || 'my_org'
username      = ENV['CHEF_USER'] ? ENV['CHEF_USER']: ENV['USER']
aws_region    = ENV['AWS_DEFAULT_REGION'] ? ENV['AWS_DEFAULT_REGION'] : "us-east-1"

current_dir = File.dirname(__FILE__)

#
# Refactored all the AWS and Chef key path and credentials to here
#
# Sets up credentials for AWS and Chef. Sets appropiate attributes in
# the knife object
#
require "#{current_dir}/creds.rb"
config = Creds::Init.new(knife, current_dir, organization, aws_region)
key_dir = config.key_dir

# If you want to use encrypted databags use the --secret or --secret-file on the knife upload
# knife[:secret_file] = "#{key_dir}/databag_secret"
knife[:region] = aws_region

log_level                :info
log_location             STDOUT
node_name                username
client_key               ENV['CHEF_CLIENT_KEY_PATH'] || "#{key_dir}/#{username}.pem"
validation_client_name   "#{organization}-validator"
validation_key           "#{key_dir}/#{organization}-validator.pem"
chef_server_url          ENV['CHEF_SERVER_URL'] || "https://api.opscode.com/organizations/#{organization}"

syntax_check_cache_path  "#{current_dir}/syntax_check_cache"
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
cookbook_path           [ "#{current_dir}/../cookbooks", "#{current_dir}/../site-cookbooks" ]
chef_repo_path          File.expand_path('../..', current_dir)
