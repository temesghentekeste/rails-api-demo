require 'rails_helper'

describe 'Books API', type: :request do
    let(:first_author) { FactoryBot.create(:author, first_name:'George', last_name: 'Orwell', age: 46 )}
    let(:second_author) { FactoryBot.create(:author, first_name:'Temesghen', last_name: 'Bahta', age: 32 )}

    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: '1984', author: first_author)
            FactoryBot.create(:book, title: 'Current times', author: second_author)
            
        end
          it 'returns all books' do 

                get '/api/v1/books'
                
                expect(response).to have_http_status(:success)
                
                expect(response_body.size).to eq(2)
                
                expect(response_body).to eq([
                    {
                        "id" =>  1,
                        "title" => "1984",
                        "author_name" =>  "George Orwell",
                        "author_age" =>  46
                    },
                    {
                        "id" =>  2,
                        "title" => "Current times",
                        "author_name" =>  "Temesghen Bahta",
                        "author_age" =>  32
                    }
                    ])
                end
                
         it 'returns a subset of books based on limit' do
            get '/api/v1/books', params: { limit: 1}

            expect(response).to have_http_status(:success)
        
            expect(response_body.size).to eq(1)
            
            expect(response_body).to eq([
                {
                    "id" =>  1,
                    "title" => "1984",
                    "author_name" =>  "George Orwell",
                    "author_age" =>  46
                },
               
                ])
          end

          it 'returns a subset of books based on limit and offset' do
            get '/api/v1/books', params: { limit: 1, offset: 1}
            expect(response).to have_http_status(:success)
        
            expect(response_body.size).to eq(1)
            
            expect(response_body).to eq([
                {
                    "id" =>  2,
                    "title" => "Current times",
                    "author_name" =>  "Temesghen Bahta",
                    "author_age" =>  32
                }
               
                ])
              
          end

    end

    describe 'POST /books' do
        it 'creates a new book' do
           expect{
            post '/api/v1/books', params: {
                book: { title: 'The Martian'},
                author: {first_name: 'Andy', last_name: 'Weir', age: 46}
            }, headers: {"Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"}
           }.to change { Book.count }.from(0).to(1)

            expect(response).to have_http_status(:created) #201
            expect(Author.count).to eq(1)

            expect(response_body).to eq({
                "id" =>  1,
                "title" => "The Martian",
                "author_name" =>  "Andy Weir",
                "author_age" =>  46

            })
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book, title: 'Dummy Book', author: first_author)}
        
        it 'deletes a book' do
           
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)


            expect(response).to have_http_status(:no_content)
        end
    end
  

end