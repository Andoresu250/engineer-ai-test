class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def render_collection(root, collection, serializer)
    json = {}
    json[root] = ActiveModelSerializers::SerializableResource.new(
        collection, each_serializer: serializer
    )
    json['total_count'] = collection.count
    render json: json, status: :ok
  end
  def validation_error(resource)
    render_error(message: 'Bad Request', errors: resource.errors)
  end

  def render_not_found
    render_error(message: 'Not found', status: :not_found)
  end

  def render_owner_error
    render_error(message: 'This resource do not belongs to you', status: :unauthorized)
  end

  def render_error(message:, errors: nil, status: :bad_request)
    render json: { success: false, message: message, errors: errors }, status: status
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
