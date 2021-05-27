module ExceptionHandler
    extend ActiveSupport::Concern

    included do
        # Model validation exceptions
        rescue_from ActiveRecord::RecordNotFound do |e|
            json_response(json_api_errors(
                [{ code: 'not_found', detail: e.message }]
            ), :not_found)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
            json_response(json_api_errors(
                [{ code: 'validation_error', detail: e.message }]
            ), :unprocessable_entity)
        end

        # Param validation exceptions
        rescue_from ActionController::ParameterMissing do |e|
            json_response(json_api_errors(
                [{ code: 'validation_error', detail: "JSON attribute '#{e.param}' is missing" }]
            ), :unprocessable_entity)
        end
    end
end