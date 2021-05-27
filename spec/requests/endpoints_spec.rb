require 'rails_helper'

RSpec.describe 'Endpoints API', type: :request do
    let!(:endpoints) { create_list(:endpoint, 10) }
    let(:endpoint_id) { endpoints.first.id }

    let(:valid_endpoint) {{
        data: {
            attributes: {
                verb: 'GET',
                path: '/greeting',
                response: {
                    code: 200,
                    headers: {
                        'Cache-Control': 'max-age=3600',
                        'Last-Modified': 'Thu, 27 May 2021 14:00:00 GMT'
                    },
                    body: "{ \"message\": \"Hello, everyone\" }"
                }
            }
        }
    }}

    let(:invalid_endpoint) {{
        data: {
            attributes: {
                verb: 'INVALID_VERB',
                path: '/greeting',
                response: {
                    code: 200,
                    headers: {},
                    body: ""
                }
            }
        }
    }}

    let(:invalid_json) {{
        verb: 'GET',
        path: '/greeting',
        response: {
            code: 200,
            headers: {},
            body: ""
        }
    }}

    describe 'GET /endpoints' do
        before { get '/endpoints' }

        it 'returns endpoints' do
            expect(json).not_to be_empty
            expect(json['data'].size).to eq(10)         
        end

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end
    end

    describe 'GET /endpoints/:id' do
        before { get "/endpoints/#{endpoint_id}" }

        context 'when the endpoint exists' do
            it 'returns the endpoint' do
                expect(json).not_to be_empty
                expect(json['data']['id']).to eq(endpoint_id)
            end

            it 'returns status 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the endpoint does not exist' do
            let(:missing_endpoint_id) { 100 }
            before { get "/endpoints/#{missing_endpoint_id}" }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

            it 'returns a not found error message' do
                expect(response.body).to match(/Couldn't find Endpoint with 'id'=#{missing_endpoint_id}/)
            end

            it 'returns a not found error code' do
                expect(json['errors'][0]['code']).to eq('not_found')
            end
        end
    end

    describe 'POST /endpoints' do
        context 'when the request is valid' do
            before { post '/endpoints', params: valid_endpoint }

            it 'creates an endpoint' do
                expect(json['data']['attributes']['path']).to eq('/greeting')
            end

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end

        context 'when the endpoint definition is invalid' do
            before { post '/endpoints', params: invalid_endpoint }
            
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns validation error details' do
                expect(response.body).to match(/Verb 'INVALID_VERB' is not a supported HTTP method/)
            end

            it 'returns a validation error code' do
                expect(json['errors'][0]['code']).to eq('validation_error')
            end
        end

        context 'when the json:api definition is invalid' do
            before { post '/endpoints', params: invalid_json }
            
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation error' do
                expect(response.body).to match(/JSON attribute 'data' is missing/)
            end

            it 'returns a validation error code' do
                expect(json['errors'][0]['code']).to eq('validation_error')
            end
        end
    end

    describe 'PATCH /endpoints/:id' do
        context 'when the request is valid' do
            before { patch "/endpoints/#{endpoint_id}", params: valid_endpoint }

            it 'updates an endpoint' do
                expect(json['data']['attributes']['path']).to eq('/greeting')
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the endpoint definition is invalid' do
            before { patch "/endpoints/#{endpoint_id}", params: invalid_endpoint }
            
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation error' do
                expect(response.body).to match(/Verb 'INVALID_VERB' is not a supported HTTP method/)
            end
        end

        context 'when the json:api definition is invalid' do
            before { patch "/endpoints/#{endpoint_id}", params: invalid_json }
            
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation error' do
                expect(response.body).to match(/JSON attribute 'data' is missing/)
            end
        end
    end

    describe 'DELETE /endpoints/:id' do
        before { delete "/endpoints/#{endpoint_id}" }

        it 'returns status code 204' do
            expect(response).to have_http_status(204)     
        end
    end
end