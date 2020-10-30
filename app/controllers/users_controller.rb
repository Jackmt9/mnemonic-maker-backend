class UsersController < ApplicationController
    
    before_action :authorized, only: [:stay_logged_in]
  
    def create
      @user = User.create(user_params)
      if @user.valid?
        wristband = encode_token({user_id: @user.id})
        render json: {
          user: @user,
          token: wristband
        }
      else
        render json: {message: "Failed to create a new user"}, status: 403
      end
    end
  
  
    def login
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        wristband = encode_token({user_id: @user.id})
        render json: {
          user: {id: @user.id, first_name: @user.first_name, last_name: @user.last_name, email: @user.email},
          token: wristband
        }
      else
        render json: {message: "Incorrect username or password"}
      end
    end
  
  
  
    def stay_logged_in
      # @user comes from the before_action
      wristband = encode_token({user_id: @user.id})
      render json: {
        user: {id: @user.id, first_name: @user.first_name, last_name: @user.last_name, email: @user.email},
        token: wristband
      }
    end
  
  
    private
  
    def user_params
      params.permit(:email, :password, :first_name, :last_name)
    end
  
  
  end
  