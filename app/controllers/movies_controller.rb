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

    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:sort] = params[:sort] unless params[:sort].nil?

    if params[:sort] == "title"
      @movies = Movie.order(title: :asc)
      @title_header = "hilite"
    elsif params[:sort] == "date"
      @movies = Movie.order(release_date: :asc)
      @release_date_header = "hilite"
    else
      if params[:ratings] == nil
        redirect_to movies_path("ratings" => session[:ratings])
      end
      if params[:ratings] == nil
        params[:ratings] = {"G"=>"1", "PG"=>"1", "PG-13"=>1, "R"=>"1"}
      end
      @movies = Movie.with_ratings(params[:ratings].keys)
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
