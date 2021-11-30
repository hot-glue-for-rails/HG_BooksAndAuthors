class BooksController < ApplicationController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_book, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }


  # TODO: implement current_user or use Devise


  

  



  def load_book
    @book = Book.find(params[:id])
  end
  

  def load_all_books
    @books = Book.page(params[:page])
  end

  def index
    load_all_books
    respond_to do |format|
       format.html
    end
  end

  def new 
    @book = Book.new
   
    respond_to do |format|
      format.html
    end
  end

  def create
    modified_params = modify_date_inputs_on_params(book_params.dup )
    @book = Book.create(modified_params)

    if @book.save
      flash[:notice] = "Successfully created #{@book.name}"
      load_all_books
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to books_path }
      end
    else
      flash[:alert] = "Oops, your book could not be created."
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    if @book.update(modify_date_inputs_on_params(book_params))
      flash[:notice] = "Saved #{@book.name}"
    else
      flash[:alert] = "Book could not be saved."
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def destroy
    begin
      @book.destroy
    rescue StandardError => e
      flash[:alert] = "Book could not be deleted"
    end
    load_all_books
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to books_path }
    end
  end

  def book_params
    params.require(:book).permit( [:name, :author_id, :blurb, :long_description, :cost, :how_many_printed, :approved_at, :release_on, :time_of_day, :selected, :genre] )
  end

  def default_colspan
    11
  end

  def namespace
    ""
  end
end


