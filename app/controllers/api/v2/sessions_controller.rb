class Api::V2::SessionsController < Api::V2::BaseController
    def create
        user = User.find_by(email: session_params[:email])

        if user && user.valid_password?(session_params[:password])
            #Metodo do próprio devide para controle de sign-in, o store:false é por que estamos usando como API e não precisa gravar a sessão
            sign_in user, store: false
            #depois que eu entro na ferramenta, um novo token é gerado
            user.generate_authentication_token!
            user.save
            render json: user, status: 200
        else
           render json: {errors: 'Invalid email and/or password'}, status: 401 
        end
    end

    def destroy
        user = User.find_by(auth_token: params[:id])
        user.generate_authentication_token!
        user.save
        head 204
    end
    private
    def session_params
        params.require(:session).permit(:email, :password)
    end
end
