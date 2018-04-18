class Api::V2::TaskTypesController < Api::V2::BaseController

    before_action :authenticate_user!
    
    def index
        task_types = TaskType.ransack(params[:q]).result
        render json: task_types, status: 200
    end

    def show
        task_type = TaskType.find(params[:id])
        render json: task_type, status: 200
    end

    def create
        task_type = TaskType.new(task_type_params)
        if task_type.save
            render json: task_type, status: 201
        else
            render json: { errors: task_type.errors }, status: 422
        end 
    end

    def update
        task_type = TaskType.find(params[:id])

        if task_type.update_attributes(task_type_params)
            render json: task_type, status: 200
        else
            render json: { errors: task_type.errors }, status: 422
        end
    end

    def destroy
        task_type = TaskType.find(params[:id])
        task_type.destroy
        head 204
    end

    private
    def task_type_params
        params.require(:task_type).permit(:name)
    end
end
