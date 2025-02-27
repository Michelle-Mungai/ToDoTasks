class ApplicationController < ActionController::API

  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end

  def decode_token
    # get the token from the headers
    auth_header = request.headers['Authorization']
    # check whether the token is present
    if auth_header
      # 'Bearer hafsdhfgjsdhvbd' split(' ')[1]
      token = auth_header.split('')[1]
      # Wrap the decoding process within an exception      
      begin
        JWT.decode(token, 'secret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    # use the decoded token method to get user details
    decoded_token = decode_token()

    if decoded_token
    # take out the user id
      user_id = decoded_token[0]['id']
      # [{payload}, {header}, {verify_signature}]
      # {
      #     "id": 10,
      #     "firstName": "John"
      # }

    # find the user that matches the id
    user = User.find_by(id: user_id)
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def authorize
    render json: { message: 'Unauthorized access' }, status: :unauthorized unless authorized_user
  end
end
