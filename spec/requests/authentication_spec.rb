require 'rails_helper'

describe 'Authentication', type: :request do
    
    describe 'POST/authenticate' do
        it 'authenticates the client' do
            post '/api/v1/authenticate', params: { username: 'BookSeller99', password: 'password1'}

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                'token' => 123
            })
        end

        it 'returns error when username is missing' do
            post '/api/v1/authenticate', params: { password: 'password1'}
            expect(response).to have_http_status(:unprocessable_entity) #422
            expect(response_body).to eq({
                'error' => 'Invalid username or password'
            })
        end
        
        it 'returns error when password is missing' do
            post '/api/v1/authenticate', params: { username: 'BookSeller99'}
            expect(response).to have_http_status(:unprocessable_entity) #422
            expect(response_body).to eq({
                'error' => 'Invalid username or password'
            })
        end
    end
end

