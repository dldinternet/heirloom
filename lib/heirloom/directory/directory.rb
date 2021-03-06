module Heirloom

  class Directory

    include Heirloom::Utils::File

    def initialize(args)
      @config  = args[:config]
      @exclude = args[:exclude] ||= []
      @path    = args[:path]
      @file    = args[:file]
      @logger  = @config.logger
    end

    def build_artifact_from_directory(args)
      @secret = args[:secret]

      @logger.debug "Building Heirloom '#{@file}' from '#{@path}'."
      @logger.debug "Excluding #{@exclude.to_s}."

      return build_archive unless @secret

      build_encrypted_archive 
    end

    private

    def build_archive
      return false unless tar_in_path?
      command = "cd #{@path} && tar czf #{@file} #{build_exclude_files} ."
      @logger.info "Archiving with: `#{command}`"
      output = `#{command}`
      @logger.debug "Exited with status: '#{$?.exitstatus}' ouput: '#{output}'"
      $?.success?
    end

    def build_encrypted_archive
      return false unless build_archive
      @logger.info "Secret provided. Encrypting."
      cipher_file.encrypt_file :file   => @file,
                               :secret => @secret
    end

    def tar_in_path?
      unless which('tar')
        @logger.error "tar not found in path."
        return false
      end
      true
    end

    def build_exclude_files
      @exclude.map { |x| "--exclude #{x}" }.join ' '
    end

    def cipher_file
      @cipher_file = Heirloom::Cipher::File.new :config => @config
    end

  end
end
