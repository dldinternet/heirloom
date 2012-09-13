module Heirloom
  module CLI
    class Setup

      include Heirloom::CLI::Shared

      def initialize
        @opts = read_options
        @logger = HeirloomLogger.new :log_level => @opts[:level]
        @config = load_config :logger => @logger,
                              :opts   => @opts

        ensure_valid_options :provided => @opts, 
                             :required => [:metadata_region, 
                                           :region, :name],
                             :config   => @config

        @catalog = Heirloom::Catalog.new :name    => @opts[:name],
                                         :config  => @config
        @archive = Archive.new :name   => @opts[:name],
                               :config => @config
      end

      def setup
        ensure_valid_region :region => @opts[:metadata_region],
                            :config => @config
        ensure_valid_regions :regions => @opts[:region],
                             :config  => @config
        ensure_metadata_in_upload_region :config  => @config, 
                                         :regions => @opts[:region]

        @catalog.create_catalog_domain

        base = @opts[:base] || @opts[:name] + (0...8).map{97.+(rand(25)).chr}.join

        unless @catalog.add_to_catalog :regions => @opts[:region],
                                       :base    => base
           if @opts[:force]
             @logger.warn "#{@opts[:name]} already exists."
           else
             @logger.warn "#{@opts[:name]} already exists, exiting."
             exit 1
           end
        end

        @archive.setup :regions       => @opts[:region],
                       :bucket_prefix => base
      end

      private

      def read_options
        Trollop::options do
          version Heirloom::VERSION
          banner <<-EOS

Setup S3 and SimpleDB in the given regions.

Usage:

heirloom setup -b BASE -n NAME -m REGION1 -r REGION1 -r REGION2

Base will be randomly generated if not specified.

EOS
          opt :base, "Base prefix which will be combined with given regions \
region. For example: '-b test -r us-west-1 -r us-east-1' will create bucket test-us-west-1 \
in us-west-1 and test-us-east-1 in us-east-1.", :type => :string
          opt :help, "Display Help"
          opt :force, "Force setup even if entry already exists in catalog."
          opt :level, "Log level [debug|info|warn|error].", :type    => :string,
                                                            :default => 'info'
          opt :metadata_region, "AWS region to store Heirloom metadata.", :type    => :string,
                                                                          :default => 'us-west-1'
          opt :name, "Name of Heirloom.", :type => :string
          opt :region, "AWS Region(s) to upload Heirloom. \
Can be specified multiple times.", :type  => :string, 
                                   :multi => true,
                                   :default => 'us-west-1'
          opt :aws_access_key, "AWS Access Key ID", :type => :string, 
                                                    :short => :none
          opt :aws_secret_key, "AWS Secret Access Key", :type => :string, 
                                                        :short => :none
        end
      end

    end
  end
end
