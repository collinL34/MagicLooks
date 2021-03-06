class UsersController < ApplicationController
  layout "application"

    def index
      #Save all the variables from the Weather API.
      @image = WeatherHelper.weatherimage
      @temp = WeatherHelper.weathertemp
      @weatherdesc = WeatherHelper.weatherdesc
      @weatherloc = WeatherHelper.weatherlocation
      @quote = WeatherHelper.quote("happy")
      @titles = NewsHelper.titles
    end


    def show
      @user = User.find(params[:id])
      
      if correct_user
         respond_to do |f|
          f.html { render 'show' }
          f.js {}
        end
      else
        redirect_to '/'
      end
    end
    
    def new
      @user = User.new
    end

    def edit
      @user = User.find(params[:id])

      #Verifies the logged in user matches the edit page
      if current_user == @user
        render 'edit'
      else
        #Redirect to the home page if the user is incorrect.
        redirect_to root_path
      end
    end

    def create
	    @user = User.new(user_params)

	    if @user.save
	      session[:user_id] = @user.id
	      redirect_to '/'
	    else
        @errors = @user.errors.full_messages
	      render 'new'
	    end

    end

    def update
      @user = User.find(params[:id])
      # if current_user == @user
        if @user.update(user_params)
          redirect_to user_path(current_user)
        else
          @errors = @user.errors.full_messages
          render 'edit'
        end
      # end
    end



  private

  def user_params
    params.require(:user).permit(:name, :email, :link, :password, :password_confirmation)
  end
  
end