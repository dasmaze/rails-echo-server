module ExceptionHandler
    extend ActiveSupport::Concern

    included do
        # Model validation exceptions
        rescue_from ActiveRecord::RecordNotFound do |e|
            json_response({ message: e.message }, :not_found)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
            json_response({ message: e.message }, :unprocessable_entity)
        end

        # Param validation exceptions
        rescue_from ActionController::ParameterMissing do |e|
            json_response({ message: "JSON attribute '#{e.param}' is missing" }, :unprocessable_entity)
        end
    end
end