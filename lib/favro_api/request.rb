require_relative './response'
require_relative '../inflector'

module FavroApi
  class Request
    extend Inflector

    API_URL = 'https://favro.com/api/v1'.freeze

    METHODS = %i(
            cards
            collections
            comments
            custom_fields
            organizations
            tags
            tasks
            tasklists
            users
            widgets
            activities
    ).freeze

    ENDPOINTS = METHODS.map{ |m| [m, "/#{jsize(m)}"] }.to_h.freeze

    attr_accessor :connection, :url, :endpoint, :params, :method,
      :last_response, :page, :owner_endpoint

    def initialize(options = {})
      self.url            = options[:url]
      self.endpoint       = options[:endpoint]
      self.method         = options[:method] || :get
      self.params         = options[:params] || {}
      self.last_response  = options[:last_response]
      self.page           = options[:page]
      self.owner_endpoint = options[:owner_endpoint]
    end

    def fetch
      self.connection = Faraday.new("#{uri.scheme}://#{uri.hostname}") do |faraday|
        faraday.adapter :net_http
        faraday.basic_auth(FavroApi.auth.email, FavroApi.auth.token)
        faraday.headers['organizationId'] = params.delete(:organization_id)
        faraday.params['page']      = page || (last_response ? last_response.page + 1 : 0)
        faraday.params['requestId'] = last_response&.request_id
      end

      puts uri.request_uri
      response = Response.new(response: connection.send(method, uri.request_uri, params))

      # if response.error?
      #   raise ApiError, "Got API error. Code: #{response.status}, message: #{response.body}"
      # end

      response
    end

    class << self
      def fetch(endpoint, page: nil, last_response: nil, owner_endpoint: nil, params: {})
        new(
          endpoint:       endpoint,
          last_response:  last_response,
          page:           page,
          method:         :get,
          params:         params,
          owner_endpoint: owner_endpoint
        ).fetch
      end
    end

    def url
      @url ||= api_url_for(endpoint)
    end

    private

    def api_url_for(endpoint)
      path = (owner_endpoint.to_s + ENDPOINTS[endpoint]) || raise(ApiError, "Unknown endpoint #{endpoint}")
      "#{API_URL}#{path}"
    end

    def uri
      URI(url)
    end
  end
end
