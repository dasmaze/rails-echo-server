class EndpointsController < ApplicationController
    def index
        @endpoints = Endpoint.all
        json_response(json_api_endpoints(@endpoints))
    end

    def create
        @endpoint = Endpoint.create!(endpoint_attributes)
        json_response(json_api_endpoint(@endpoint), :created)
    end

    def show
        @endpoint = Endpoint.find(params[:id])
        json_response(json_api_endpoint(@endpoint))
    end

    def update
        @endpoint = Endpoint.find(params[:id])
        @endpoint.update!(endpoint_attributes)
        json_response(json_api_endpoint(@endpoint))
    end

    def destroy
        @endpoint = Endpoint.find(params[:id])
        @endpoint.destroy
        head :no_content
    end

    private

    # Request validation and parsing
    def endpoint_params
        params.require(:data).permit(:type, {
            attributes: [:verb, :path, response: [:code, :body, headers: {}]]
        })
    end

    def endpoint_attributes
        attributes = endpoint_params[:attributes]
        endpoint = {
            verb: attributes[:verb],
            path: attributes[:path],
            response_code: attributes[:response][:code],
            headers: header_attributes,
            response_body: attributes[:response][:body]
        }
    end

    def header_attributes
        headers = endpoint_params[:attributes][:response][:headers].to_h.map {
            |name, value| Header.new({ name: name, value: value })
        }
        headers
    end
end