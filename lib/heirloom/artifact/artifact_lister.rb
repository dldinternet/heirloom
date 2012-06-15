module Heirloom

  class ArtifactLister

    def initialize(args)
      @config = Config.new
    end

    def versions(args)
      domain = args[:name]
      sdb.select("select * from #{domain}").keys
    end

    def list
      sdb.domains
    end

    private

    def sdb
      @sdb ||= AWS::SimpleDB.new :config => @config
    end

  end
end
