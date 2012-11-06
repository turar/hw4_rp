class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      @title_header = 'hilite'
    when 'release_date'
      @date_header = 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    @similar_movie_id = params[:similar_movie]

    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings, :similar_movie => @similar_movie_id and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings, :similar_movie => @similar_movie_id and return
    end
#@movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)

    @message = ''
    if @similar_movie_id.blank?
      @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings.keys}, :order => sort)
    else
      similar_movie = Movie.find(@similar_movie_id)
      director = similar_movie.director
      if director != nil and not director.blank?
        @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings.keys, :director => director}, :order => sort)
      else
        @message = "'#{similar_movie.title}' has no director info"
        @movies = Movie.find(:all, :conditions => {:id => @similar_movie_id} )
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
