require_relative './request'
require_relative './data_types'

module FavroApi
  class Driver
    FavroApi::Request::METHODS.each do |m|
      define_method(m) do |params = {}|

        response = paginated_request(m, params).fetch

        m == :custom_fields ?
          response.parse
        :
          response.parse(type: Kernel.const_get("FavroApi::DataTypes::#{m.to_s.singularize.capitalize}"))
      end
    end

    private

    def paginated_request(endpoint, params)
      Request.new(
        endpoint: endpoint,
        page: params.delete(:page),
        last_response: params.delete(:last_response),
        owner_endpoint: params.delete(:owner_endpoint),
        params: params
      )
    end
  end
end
