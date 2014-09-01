require 'inifile'

module Creds
  class Init
    
    attr_accessor :key_dir
    
    def initialize(knife, current_dir, organization, aws_region)
      # Location for ssh and aws pem keys
      #
      # First check for if there is a profile oriented key directory
      # If not, use the same directory as the knife.rb (this file)
      # Can be overridden by ENV['CHEF_KEY_DIR']
      #
      meta_key_dir = File.expand_path("~/.chef/keys/#{organization}")
      default_key_dir = File.exist?(meta_key_dir) ? meta_key_dir : current_dir
      @key_dir       = ENV['CHEF_KEY_DIR'] || default_key_dir
      knife[:key_dir] = @key_dir

      # Pull in the AWS access credentials
      aws = {}
      credentials_ini_file = File.expand_path("~/.aws/config")

      if File.exist?(credentials_ini_file)
        begin
          inifile = IniFile.load(File.expand_path(credentials_ini_file))
          inifile.each_section do |section|
            if section =~ /^\s*profile\s+(.+)$/ || section =~ /^\s*(default)\s*/
              profile = $1.strip
              aws[profile] = {
                              :access_key_id => inifile[section]['aws_access_key_id'],
                              :secret_access_key => inifile[section]['aws_secret_access_key'],
                              :region => inifile[section]['region']
                             }
            end
          end
        rescue Exception => e
          STDERR.puts "Can not process inifile: #{credentials_ini_file}: #{e}"
          exit(-1)
        end
        if aws[organization]
          knife[:aws_access_key_id]     = aws[organization][:access_key_id]
          knife[:aws_secret_access_key] = aws[organization][:secret_access_key]
        elsif aws['default']
          knife[:aws_access_key_id]     = aws['default'][:access_key_id]
          knife[:aws_secret_access_key] = aws['default'][:secret_access_key]
        else
          STDERR.puts "No valid AWS config in ini config file: #{credentials_ini_file}"
          exit(-1)
        end
      elsif (ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY'])
        STDERR.puts "knife.rb: Can not find AWS Profile file #{credentials_ini_file}; Using ENV['AWS_ACCESS_KEY_ID']: #{ENV['AWS_ACCESS_KEY_ID'].inspect}"
        knife[:aws_access_key_id]      = ENV['AWS_ACCESS_KEY_ID']
        knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
      else
        STDERR.puts "knife.rb: Can not find AWS Profile file #{credentials_ini_file.inspect} or ENV['AWS_ACCESS_KEY_ID']; Not initializing AWS Credentials"
      end

      knife[:region] = aws_region if knife[:aws_access_key_id] && knife[:aws_secret_access_key]
    end
  end
end
