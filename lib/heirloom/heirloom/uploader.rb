module Heirloom

  class Uploader

    def initialize(args)
      @config = args[:config]
      @name = args[:name]
      @id = args[:id]
      @logger = @config.logger
    end

    def upload(args)
      heirloom_file = args[:file]
      bucket_prefix = args[:bucket_prefix]
      public_readable = args[:public_readable]

      @config.regions.each do |region|
        bucket = "#{bucket_prefix}-#{region}"

        s3_uploader = Uploader::S3.new :config => @config,
                                       :logger => @logger,
                                       :region => region

        s3_uploader.upload_file :bucket          => bucket,
                                :file            => heirloom_file,
                                :id              => @id,
                                :key_folder      => @name,
                                :key_name        => "#{@id}.tar.gz",
                                :name            => @name,
                                :public_readable => public_readable

        s3_uploader.add_endpoint_attributes :bucket     => bucket,
                                            :id         => @id,
                                            :name       => @name
      end
      @logger.info "Upload complete."
    end

  end
end
