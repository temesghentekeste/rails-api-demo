module Api
  module V1
    class BooksController < ApplicationController

      MAX_PAGINATION_LIMIT = 100

      def index
        books = Book.all
        books = Book.limit(limit).offset(params[:offset])
        
        render json: BooksRepresenter.new(books).as_json 
      end

      def create 
        # binding.irb
        author = Author.create!(author_params)
        book = Book.new(book_params.merge(author_id: author.id))

        if book.save
          render json: BookRepresenter.new(book).as_json , status: :created #201
        else
          render json: book.errors, status: :unprocessable_entity #422
        end
      end

      def destroy 
        Book.find(params[:id]).destroy!

        head :no_content

      end
        
        private

        def limit
          [
            params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
            MAX_PAGINATION_LIMIT
          ].min
        end
        
        def author_params
          params.require(:author).permit(:first_name, :last_name, :age)
        end

        def book_params
          params.require(:book).permit(:title, :author)
        end
        
      
    end
  end
end