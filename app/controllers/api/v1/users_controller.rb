class Api::V1::UsersController < ApplicationController

    respond_to :json

    def show
        begin
            @user = User.find(params[:id])
            respond_with @user
        rescue 
            head 404
        end
    end

    def create
        user = User.new(user_params)

        if user.save
            render json: user, status: 201
        else
            # byebug #excelente ferramenta para debugar código, deste ponto para frente ele gera um debug passo a passo com a posssibilidade de acessar qualquer variavel local
            #para continuar o debug, é só apertar a letra 'c' 
            render json: { errors: user.errors }, status: 422
        end
    end

    def update
        user = User.find(params[:id])

        if user.update(user_params)
            render json: user, status: 200
        else
            render json: { errors: user.errors }, status: 422
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
end
