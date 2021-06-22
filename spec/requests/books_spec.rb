require 'rails_helper'

describe 'Books API', type: :request do
    it 'returns all books' do 
        get '/api/v1/books'

        expect(response).to have_http_status(:success)
    end

end