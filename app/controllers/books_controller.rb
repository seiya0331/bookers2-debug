class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @user = @book.user
    @booknew = Book.new
    @book_comment = BookComment.new


  end

  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to-6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by{|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :'index'
    end
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private


  def is_matching_login_user
    @book = Book.find(params[:id])

    if(@book.user_id != current_user.id)
      redirect_to books_path
    end
  end


  def book_params
    params.require(:book).permit(:title, :body)
  end
end
