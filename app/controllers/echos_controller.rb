class EchosController < ApplicationController
    def echo
        p request
        echo_path = echo_path(params[:echo_endpoint])
        endpoint = Endpoint.where(["path = :path AND verb = :verb", { path: echo_path, verb: request.method }]).first!
        endpoint.headers.each { |header| response.set_header(header.name, header.value) }
        render plain: endpoint.response_body, status: endpoint.response_code
    end
end