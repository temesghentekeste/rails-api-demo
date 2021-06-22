## Nile

A rails api project.

1. routes: example, resources :books
************************************************************************************
************************************************************************************
2. Basic controllers and models
 example: 
 
 step I Generating Books Controller
    rails g controller Books index
        Running via Spring preloader in process 27143
            create  app/controllers/books_controller.rb
            route  get 'books/index'
            invoke  test_unit
            create    test/controllers/books_controller_test.rb

curl http://localhost:3000/books -v
    *   Trying 127.0.0.1:3000...
    * TCP_NODELAY set
    * Connected to localhost (127.0.0.1) port 3000 (#0)
    > GET /books HTTP/1.1
    > Host: localhost:3000
    > User-Agent: curl/7.68.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 204 No Content

step II.
Generating the Book Model:
    rails g model Book title:string author:string
    Running via Spring preloader in process 30151
        invoke  active_record
        create    db/migrate/20210621174807_create_books.rb
        create    app/models/book.rb
        invoke    test_unit
        create      test/models/book_test.rb
        create      test/fixtures/books.yml
************************************************************************************
************************************************************************************
3. Creating a POST Endpoint
 step I. create a create action
 step II. update the routes, example: resources :books, only: [:index, :create]
 step III. make simple curl request:
  curl --request POST http://localhost:3000/books -v
    *   Trying 127.0.0.1:3000...
    * TCP_NODELAY set
    * Connected to localhost (127.0.0.1) port 3000 (#0)
    > POST /books HTTP/1.1
    > Host: localhost:3000
    > User-Agent: curl/7.68.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 204 No Content
    < X-Frame-Options: SAMEORIGIN
    < X-XSS-Protection: 1; mode=block
    < X-Content-Type-Options: nosniff
    < X-Download-Options: noopen
    < X-Permitted-Cross-Domain-Policies: none
    < Referrer-Policy: strict-origin-when-cross-origin
    < Cache-Control: no-cache
    < X-Request-Id: b44e2f4d-f6d5-4d27-bb2f-940d15f500d8
    < X-Runtime: 0.004630
    < 
    * Connection #0 to host localhost left intact

step IV: update the create action
    def create 
        book = Book.new(book_params)

        if book.save
        render json: book, status: :created 
        else
        render json: book.errors, status: :unprocessable_entity
        end
    end

    private

    def book_params
        params.require(:book).permit(:title, :author)
    end
step V: make curl request as follows
  curl --header "Content-Type: application/json" --request POST --data '{"author": "temesghen tekeste", "title": "Coding Challenges"}' http://localhost:3000/books



4. HTTP Status Codes
https://gist.github.com/mlanett/a31c340b132ddefa9cca
************************************************************************************
************************************************************************************

5. Active Record Vaildation
class Book < ApplicationRecord
    validates :author, presence: true, length: { minimum: 3}
    validates :title, presence: true, length: { minimum: 3}
end

curl --header "Content-Type-vapplication/json" --request POST --data '{"title": "JK", "author": "HP"}' http://localhost:3000/books  
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /books HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 31
> 
* upload completely sent off: 31 out of 31 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 422 Unprocessable Entity
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Download-Options: noopen
< X-Permitted-Cross-Domain-Policies: none
< Referrer-Policy: strict-origin-when-cross-origin
< Content-Type: application/json; charset=utf-8
< Vary: Accept
< Cache-Control: no-cache
< X-Request-Id: 1175173c-9620-4436-ac29-e3f9573147e9
< X-Runtime: 0.005547
< Transfer-Encoding: chunked
< 
* Connection #0 to host localhost left intact
{"author":["is too short (minimum is 3 characters)"],"title":["is too short (minimum is 3 characters)"]

************************************************************************************
************************************************************************************
6. Delete
 Step I:

    Rails.application.routes.draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :books, only: [:index, :create, :destroy]
    end

Step II:
  def destroy 
    Book.find(params[:id]).destroy!

    head :no_content
  end

Step III:
 curl --header 'Content-Type: application/json' --request DELETE http://localhost:3000/books/6 -v
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> DELETE /books/6 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 204 No Content
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Download-Options: noopen
< X-Permitted-Cross-Domain-Policies: none
< Referrer-Policy: strict-origin-when-cross-origin
< Cache-Control: no-cache
< X-Request-Id: 54231855-26d9-44d9-b82d-f2b534934906
< X-Runtime: 0.303910
< 
* Connection #0 to host localhost left intact
************************************************************************************
************************************************************************************
7. Exception handling in controllers

  Method I:
     def destroy 
        Book.find(params[:id]).destroy!

        head :no_content

        rescue ActiveRecord::RecordNotDestroyed
        render json: {}, status: :unprocessable_entity
    end

  Method II:
   class BooksController < ApplicationController
        rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

        def index
            render json: Book.all
        end

        def create 
            book = Book.new(book_params)

            if book.save
            render json: book, status: :created #201
            else
            render json: book.errors, status: :unprocessable_entity #422
            end
        end

        def destroy 
            Book.find(params[:id]).destroy!

            head :no_content

        end
            
            private
            
            def book_params
            params.require(:book).permit(:title, :author)
            end
            
            def not_destroyed
            render json: {}, status: :unprocessable_entity
        end
    end

Method III:
    class ApplicationController < ActionController::API
        rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

        def not_destroyed
            render json: {}, status: :unprocessable_entity
        end
    end

Sample Request: 
 curl --header 'Content-Type: application/json' --request DELETE http://localhost:3000/books/6 -v
    *   Trying 127.0.0.1:3000...
    * TCP_NODELAY set
    * Connected to localhost (127.0.0.1) port 3000 (#0)
    > DELETE /books/6 HTTP/1.1
    > Host: localhost:3000
    > User-Agent: curl/7.68.0
    > Accept: */*
    > Content-Type: application/json
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 404 Not Found
    < Content-Type: application/json; charset=UTF-8
    < X-Request-Id: 72219f11-3693-450f-b3eb-4376eb701cb0
    < X-Runtime: 0.063520
    < Content-Length: 14080
    < 
    {"status":404,"error":"Not Found","exception":"#\u003cActiveRecord::RecordNotFound: Couldn't find Book with 'id'=6\u003e","traces":{"Application Trace":[{"exception_object_id":26900,"id":1,"trace":"app/controllers/books_controller.rb:18:in `destroy

************************************************************************************
************************************************************************************
8. Namespacing and versioning
   Example: 
   Step I.
        Rails.application.routes.draw do
            namespace :api do
                namespace :v1 do 
                resources :books, only: [:index, :create, :destroy]
                end
            end
        end

    Step II.
     Put the books cotroller inside controllers/api/v1 folder 
    Step III: test 
     curl http://localhost:3000/api/v1/books
[{"id":1,"title":"Rails API","author":"Temesghen","created_at":"2021-06-21T17:59:03.891Z","updated_at":"2021-06-21T17:59:03.891Z"},{"id":2,"title":"Bleachers","author":"John Grisham","created_at":"2021-06-21T20:48:31.868Z","updated_at":"2021-06-21T20:48:31.868Z"},{"id":3,"title":"Coding Challenges","author":"temesghen tekeste","created_at":"2021-06-21T20:58:18.316Z","updated_at":"2021-06-21T20:58:18.316Z"},{"id":7,"title":"JK Harwing","author":"Harry Potter I","created_at":"2021-06-22T08:56:56.268Z","updated_at":"2021-06-22T08:56:56.

************************************************************************************
************************************************************************************
9. API Tests with RSpec 
 Step I.
  group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
    gem 'rspec-rails'
  end

  Step II: rails generate rspec:install
  Step III: bundle exec rspec
  Step IV: create books_spec.rb file inside the generated spec folder
   Sample Test:

   ````
    require 'rails_helper'

    describe 'Books API', type: :request do
        it 'returns all books' do 
            get '/api/v1/books'

            expect(response).to have_http_status(:success)
        end

    end
   ````
