class TasksController < ApplicationController

    def index
        tasks = Task.all
        render json: tasks
    end
    def create
        task = Task.create!(task_params)
        if task.valid?
            render json: task, status: :accepted
        else
            render json: {errors: "An error occured"}
        end
    end
    def update
        task = Task.find(params[:id])
        task.update(task_params)
        render json: task
    end
    def destroy
        task = Task.find(params[:id])
        task.destroy
    end
    private
    def task_params
        params.permit(:task_name, :task_description, :task_status, :created_at, :updated_at)
    end
end
