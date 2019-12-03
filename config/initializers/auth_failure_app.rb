class AuthFailureApp < Devise::FailureApp

  def http_auth_body
    return super unless request_format == :json

    { success: false, message: 'Username/Password incorrect' }.to_json
  end

end