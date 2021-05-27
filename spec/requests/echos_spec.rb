require 'rails_helper'

RSpec.describe 'Endpoints API', type: :request do
    let!(:endpoints) {
        Endpoint.create!({
            verb: 'GET',
            path: '/greeting',
            response_code: 201,
            headers: [
                    Header.new(name: 'Cache-Control', value: 'max-age=3600, private'),
                    Header.new(name: 'Last-Modified', value: 'Thu, 27 May 2021 14:00:00 GMT')
            ],
            response_body: "{ \"message\": \"Hello, everyone\" }"
        })
    }

    describe 'call an existing endpoint' do
        before { get '/greeting' }

        it 'returns endpoints defined response' do
            expect(response.body).to eq("{ \"message\": \"Hello, everyone\" }")
        end

        it 'returns endpoints defined return code' do
            expect(response).to have_http_status(201)
        end

        it 'returns endpoints defined headers' do
            expect(response.header['Cache-Control']).to eq('max-age=3600, private')
            expect(response.header['Last-Modified']).to eq('Thu, 27 May 2021 14:00:00 GMT')
        end
    end

    describe 'call a non-existant endpoint' do
        before { get '/greetings' }

        it 'returns 404' do
            expect(response).to have_http_status(404)
        end

        it 'returns a not found error message' do
            expect(response.body).to match(/Couldn't find Endpoint with/)
        end

        it 'returns a not found error code' do
            expect(json['errors'][0]['code']).to eq('not_found')
        end
    end

    describe 'call an existing endpoint with a different method' do
        before { post '/greeting' }

        it 'returns 404' do
            expect(response).to have_http_status(404)
        end

        it 'returns a not found error message' do
            expect(response.body).to match(/Couldn't find Endpoint with/)
        end

        it 'returns a not found error code' do
            expect(json['errors'][0]['code']).to eq('not_found')
        end
    end
end