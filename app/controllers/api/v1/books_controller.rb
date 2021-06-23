module Api
  module V1
    class BooksController < ApplicationController

      def index
        books = Book.all
        render json: BooksRepresenter.new(books).as_json 
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
        
      
    end
  end
end