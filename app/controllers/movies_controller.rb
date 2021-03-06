class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if params.include?(:format)
      session[:format] = params[:format]
    end
    
    if params.include?(:ratings)
      session[:ratings]=params[:ratings]
    end
    
    if  session[:format] != params[:format] or session[:ratings]!=params[:ratings]
      flash.keep
      redirect_to movies_path(:format => session[:format], :ratings => session[:ratings])
    end
    

    
    if params.include?(:ratings)
      @rating_filter = params[:ratings].keys
    elsif params.include?(:commit)
      @rating_filter = []
    else 
      @rating_filter = @all_ratings
    end

    if params[:format] == "sort_by_title"
      @movies = Movie.where({rating: @rating_filter}).order(:title)
    elsif params[:format] == "sort_by_release_date"
      @movies = Movie.where({rating: @rating_filter}).order(:release_date)
    else
      @movies = Movie.where({rating: @rating_filter})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
end
