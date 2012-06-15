require 'heirloom/artifact/artifact_lister.rb'
require 'heirloom/artifact/artifact_reader.rb'
require 'heirloom/artifact/artifact_builder.rb'

module Heirloom

  class Artifact
    def initialize(args)
      @config = Config.new :config => args[:config]
    end

    def build(args)
      file = artifact_builder.build(args)
      artifact_uploader.upload :config => @config,
                               :id     => args[:id],
                               :name   => args[:name],
                               :file   => file
      artifact_authorizer.authorize :config => @config,
                               :id     => args[:id],
                               :name   => args[:name],
                               :file   => file
    end

    def show(args)
      artifact_reader.show(args)
    end

    def versions(args)
      artifact_lister.versions(args)
    end

    def list
      artifact_lister.list
    end

    private

    def artifact_lister
      @artifact_lister ||= ArtifactLister.new :config => @config
    end

    def artifact_reader
      @artifact_reader ||= ArtifactReader.new :config => @config
    end

    def artifact_builder
      @artifact_builder ||= ArtifactBuilder.new :config => @config
    end

    def artifact_uploader
      @artifact_uploader ||= ArtifactUploader.new :config => @config
    end

    def artifact_authorizer
      @artifact_authorizer ||= ArtifactAuthorizer.new :config => @config
    end

  end
end