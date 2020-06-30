class HomeController < ApplicationController
  def index
  end

  def signup
    @user = User.new
  end

  def register
    client = OneLogin::Api::Client.new(
      client_id: ENV['MANAGER_CLIENT_ID'],
      client_secret: ENV['MANAGER_CLIENT_SECRET'],
      region: 'us'
    )
    role_ids = client.get_roles.map(&:id)

    new_user = client.create_user(
      email: register_params[:email],
      firstname: register_params[:firstname],
      lastname: register_params[:lastname],
      username: register_params[:username]
    )

    if new_user.present?
      puts 'REGISTER COMPLETE'
      puts new_user.inspect

      # set all roles
      result = client.assign_role_to_user(new_user.id, role_ids)
      puts result.inspect

      # send invitation mail
      sent = client.send_invite_link(register_params[:email])
      puts sent.inspect
      
      render :index
    else
      puts client.error
      puts client.error_description
    end
  end

  private

  def register_params
    @register_params ||= params.require(:user).permit(:email, :firstname, :lastname, :username)
  end
end
