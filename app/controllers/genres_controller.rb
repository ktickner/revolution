class GenresController < ApplicationController
    before_action :authenticate_user!
    before_action :profile_active?
    
    def new
        @genre = Genre.new
    end
    
    def create
        @genre = current_user.genres.build(genre_params)
        if @genre.save
            redirect_to root_url
        else
            render 'new'
        end
    end
    
    private
    
        def genre_params
           params.require(:genre).permit(:name) 
        end
end
