generic-knife-config
====================

An example of making Chef knife.rb generic for user name, chef org, and to keep chef, aws and other creds outside of the chef-repo.

## Shell Environment Overrides

Default node_name / user is pulled from `ENV['CHEF_USER']` if it exists or ENV['USER']

Chef Organization will be overidden by `ENV['CHEF_ORGANIZATION']` and
defaults to 'my_org'

You can override the default `chef_server_url` with
`ENV['CHEF_SERVER_URL']`. You might do that to use chef-zero

AWS region can be overriden by  `ENV['AWS_DEFAULT_REGION']` but
defaults to `us-east-1`

## Specifibying AWS Access key via an AWS profile

Put your AWS ACCESS KEY ID and AWS SECRET ACCESS KEY and in
`~/.aws/config` or set `ENV['AWS_ACCESS_KEY_ID']` and
`ENV['AWS_SECRET_ACCESS_KEY']`

By default pulls in the AWS access credentials from the now standard
INI file at `~/.aws/config using` _organization_ as the key (defaults to `my_org`)

Alternatively you can set your shell environments `ENV['AWS_ACCESS_KEY_ID']` and `ENV['AWS_SECRET_ACCESS_KEY']`

If neither the file exists or the environment variables are net set.
It will give you a warning message and your AWS Credentials will not
be set

The `aws_region` defaults to `us_east_1`. You can override with
`ENV['AWS_DEFAULT_REGION']`

For more information on the new AWS profile file format see:
http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles

### Switching AWS Key Environment Variables

A blog post on a script you can use to switch your environment
between profiles for using the AWS ALI.

Not needed for pure Chef stuff though:
http://blog.ibd.com/howto/cli-to-switch-amazon-aws-shell-environment-credentials/


## Chef Server PEM keys and AWS ssh keys

You should put your chef server pem and AWS ssh key in `~/.chef/keys/my_org`

It gets any ssh or aws pem keys from `key_dir` (set to
`~/.chef/keys/#{organization}`) This is not a standard, but a
convienience.

If you don't have a `~/.chef/keys/my_org`, it will look in the same
directory as this knife.rb file for keys

You can also override the full path/file of the client_key with
`ENV['CHEF_CLIENT_KEY_PATH']`

## More info on Chef knife.rb

See http://docs.getchef.com/config_rb_knife.html for more
information on general knife configuration options



