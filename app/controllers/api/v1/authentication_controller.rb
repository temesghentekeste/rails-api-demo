module Api
    module V1
      class AuthenticationController < ApplicationController

        rescue_from ActionController::ParameterMissing, with: :parameter_missing

        def create
            # p params.inspect
            user = User.find_by(username: params.require(:username))
            token = AuthenticationTokenService.call(user.id)

            p params.require(:username).inspect
            p params.require(:password).inspect

            render json: { token: token}, status: :created
        end

        private

        def parameter_missing(e)
            render json: { error: "Invalid username or password"}, status: :unprocessable_entity
        end
      end
    end
end