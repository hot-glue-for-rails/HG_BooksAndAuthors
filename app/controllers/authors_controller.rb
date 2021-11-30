class AuthorsController < ApplicationController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_author, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }


  # TODO: implement current_user or use Devise


  

  



  def load_author
    @author = Author.find(params[:id])
  end
  

  def load_all_authors
    @authors = Author.page(params[:page])
  end

  def index
    load_all_authors
    respond_to do |format|
       format.html
    end
  end

  def new 
    @author = Author.new
   
    respond_to do |format|
      format.html
    end
  end

  def create
    modified_params = modify_date_inputs_on_params(author_params.dup )
    @author = Author.create(modified_params)

    if @author.save
      flash[:notice] = "Successfully created #{@author.name}"
      load_all_authors
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to authors_path }
      end
    else
      flash[:alert] = "Oops, your author could not be created."
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
    if @author.update(modify_date_inputs_on_params(author_params))
      flash[:notice] = "Saved #{@author.name}"
    else
      flash[:alert] = "Author could not be saved."
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def destroy
    begin
      @author.destroy
    rescue StandardError => e
      flash[:alert] = "Author could not be deleted"
    end
    load_all_authors
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to authors_path }
    end
  end

  def author_params
    params.require(:author).permit( [:name] )
  end

  def default_colspan
    1
  end

  def namespace
    ""
  end
end


