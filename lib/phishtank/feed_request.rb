module PhishTank
  class FeedRequest
    attr_accessor :etag
    
    def initialize(etag = nil)
      @etag = etag || PhishTank.configuration.etag
    end

    def update?
      return true if @etag.nil?
      response = head(update_uri, :headers => {"ETag" => @etag})
      response.headers_hash['Etag'] != "\"#{@etag}\""
    end
    
    def get_update
      response = get(update_uri)
      File.open("#{PhishTank.configuration.temp_directory}/online-valid.xml", 'wb') do |file|
        file.write(response.body)
      end
    end
    
    def update_uri
      "#{BASE_URI}/data/#{PhishTank.configuration.api_key}/online-valid.xml"
    end
    
    def head(uri, opts = {})
      Typhoeus::Request.head(uri, opts)
    end
    
    def get(uri, opts = {})
      Typhoeus::Request.get(uri, opts)
    end
  end
end
