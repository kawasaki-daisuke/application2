class BooksController < ApplicationController
    before_action :authenticate_user!

	def index
		@books = Book.all
		@book = Book.new
    end

	def show
		@book = Book.find(params[:id])
        @book_new = Book.new
		@user = User.find(@book.user_id)
        flash[:notice] = "You have updated book successfully."
    end

    def edit
    	@book = Book.find(params[:id])
        if current_user.id != @book.user_id
            redirect_to books_path
        end
    end

    def update
    	@book = Book.find(params[:id])
    	if @book.update(book_params)
    	   redirect_to book_path(@book.id)
        else
            @books=Book.all
            render :edit
        end
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end


    def create
    	@book = Book.new(book_params)
    	@book.user_id=current_user.id
    	if @book.save
    	  redirect_to book_path(@book.id)
        else
          @books=Book.all
          render :index
        end
    end

    private
    def book_params
    	params.require(:book).permit(:title, :body)
	end
end