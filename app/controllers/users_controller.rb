class UsersController < ApplicationController
rescue ActiveRecord::RecordNotFound, with: :not_found_response
    def index
        users = User.all
        render json: users, status: :ok
    end
    def show
        users = User.find(params[:id])
        if users
            render json: users, status: :ok
        else
            render json: {error: "User not found"}, status: :not_found
        end
    end
    def create
        user = User.create!(user_params)
        if user
            render json: user, status: :created
        else
            not_found_response
        end
    end
    def update
        user = User.find(params[:id])
        if user
            user.update(user_params)
            render json: user, status: :accepted
        else
            render json: {error: "User not found"}, status: :not_found
        end
    end
    def destroy
        user = User.find(params[:id])
        if user
            user.destroy
            head :no_content
        else
            render json: {error: "User not found"}, status: :not_found
        end
    end
    private
    def user_params
        params.permit(:username, :email, :password, :gender)
    end
    def not_found_response(user)
        render json: {error: user.record.errors.full_messages}, status: :unprocessable_entity
    end

end
