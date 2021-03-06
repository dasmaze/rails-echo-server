module Response
    def json_response(object, status = :ok)
        response.headers['Content-Type'] = 'application/vnd.api+json'
        render json: object, status: status
    end

    def json_api_endpoint(endpoint)
        {
            data: {
                type: 'endpoints',
                id: endpoint.id,
                attributes: {
                    verb: endpoint.verb,
                    path: endpoint.path,
                    response: {
                        code: endpoint.response_code,
                        headers: json_api_headers(endpoint.headers),
                        body: endpoint.response_body
                    }
                }
            }
        }
    end

    def json_api_endpoints(endpoints = [])
        {
            data: endpoints.map { |endpoint| json_api_endpoint(endpoint)[:data] }
        }
    end
    
    def json_api_headers(headers = [])
        Hash[headers.collect { |header| [header.name, header.value] }]
    end

    def json_api_errors(errors)
        {
            errors: errors.map { |error| { code: error[:code], detail: error[:detail] } }
        }
    end
end