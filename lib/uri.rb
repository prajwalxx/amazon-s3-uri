require "amazon/s3/uri/version"
require 'uri'

module Amazon
  module S3
    module Uri
      class AmazonS3URI
        ENDPOINT_PATTERN = /^(.+\.)?s3[.-]([a-z0-9-]+)\./
        attr_reader :uri, :bucket, :key, :region
        def initialize(url)
          if url.nil?
            raise ArgumentError.new("url cannot be null")
          end
          @uri = URI(url)

          @host = @uri.host
          if @host.nil?
            raise ArgumentError.new("Invalid S3 URI: no hostname: " + url)
          end

          matches = ENDPOINT_PATTERN.match(@host)

          prefix = matches[1]

          if prefix.nil? || prefix.empty?
            # No bucket name in the authority; parse it from the path.
            @isPathStyle = true
            path = uri.path
            if (path == '/')
              @bucket = nil
              @key = nil
            else
              # path genearlly in style of `/sample-bucket/temp/8746ee3e-4089-11e8-9a0b-f3d94c494e17.somaya.jpg`
              index = path.index('/', 1)
              if index.nil?
                # path if equals /sample-bucket
                # puts path
                @bucket = path[1 .. -1]
                @key = nil
              elsif index == path.length - 1
                # path if equals /sample-bucket/
                @bucket = path[1 ... index]
                @key = nil
              else
                # path if equals `/sample-bucket/temp/8746ee3e-4089-11e8-9a0b-f3d94c494e17.somaya.jpg`
                @bucket = path[1 ... index]
                @key = path[index + 1 .. -1]
              end
            end
          else
            @isPathStyle = false

            # Remove the trailing '.' from the prefix to get the bucket.
            @bucket = prefix[0 ... -1]
            path = uri.path
            if path.nil? || path.empty? || path  == '/'
              @key = nil
            else
              # Remove the leading '/'
              @key = path[ 1 .. -1]
            end
          end

          if matches[2] == 'amazonaws'
            # No region specified
            @region = nil
          else
            @region = matches[2]
          end
        end
      end
    end
  end
end
