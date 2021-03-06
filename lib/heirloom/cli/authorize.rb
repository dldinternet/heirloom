module Heirloom
  module CLI
    class Authorize

      include Heirloom::CLI::Shared

      def self.command_summary
        'Authorize access from another AWS account to an Heirloom'
      end

      def initialize
        @opts = read_options
        @logger = HeirloomLogger.new :log_level => @opts[:level]
        @config = load_config :logger => @logger,
                              :opts   => @opts

        ensure_valid_options :provided => @opts,
                             :required => [:accounts, :name, :id],
                             :config   => @config
        ensure_valid_region :region => @opts[:metadata_region],
                            :config => @config
        ensure_domain_exists :name => @opts[:name], 
                             :config => @config
        @archive = Archive.new :name   => @opts[:name],
                               :id     => @opts[:id],
                               :config => @config
        ensure_archive_exists :archive => @archive,
                              :config => @config
      end

      def authorize
        unless @archive.authorize @opts[:accounts]
          exit 1
        end
      end

      private

      def read_options
        Trollop::options do
          version Heirloom::VERSION
          banner <<-EOS

#{Authorize.command_summary}.

Usage:

heirloom authorize -n NAME -i ID -a AWS_ACCOUNT1 -a AWS_ACCOUNT2

Note: This will replace all current authorizations with those specified and make the Heirloom private.  Use the 'show' command to retrieve the existing authorizations assigned to an object.


EOS
          opt :accounts, "AWS Account(s) email or canonical_ID to authorize. Can be specified multiple times.", :type  => :string,
                                                                                                :multi => true
          opt :help, "Display Help"
          opt :id, "ID of the Heirloom to authorize.", :type => :string
          opt :level, "Log level [debug|info|warn|error].", :type    => :string,
                                                            :default => 'info'
          opt :metadata_region, "AWS region to store Heirloom metadata.", :type => :string
          opt :name, "Name of Heirloom.", :type => :string
          opt :aws_access_key, "AWS Access Key ID", :type => :string, 
                                                    :short => :none
          opt :aws_secret_key, "AWS Secret Access Key", :type => :string, 
                                                        :short => :none
          opt :use_iam_profile, "Use IAM EC2 Profile", :short => :none
          opt :environment, "Environment (defined in ~/.heirloom.yml)", :type => :string
        end
      end

    end
  end
end
