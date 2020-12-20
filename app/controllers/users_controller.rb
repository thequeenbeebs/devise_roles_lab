class UsersController < ApplicationController
    before_action :current_user

    def index 
    end

    def show
        @user = User.find(params[:id])
        if current_user.id != @user.id
            flash[:alert] = "Access denied." 
            redirect_to root_path
        end
    end

    def destroy
        @user = User.find(params[:id])
        return head(:forbidden) unless current_user.admin?
        @user.destroy
    end


end
