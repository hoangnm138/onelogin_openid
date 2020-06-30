# frozen_string_literal: true

require 'onelogin'

class DashboardController < ApplicationController
  before_action :require_current_user

  def index
    client = OneLogin::Api::Client.new(
      client_id: ENV['MANAGER_CLIENT_ID'],
      client_secret: ENV['MANAGER_CLIENT_SECRET'],
      region: 'us'
    )
    users = client.get_users

    if users.nil?
      puts client.error
      puts client.error_description
    else
      users.each do |user|
        puts user.firstname
      end
    end
    apps = client.get_apps
    if apps.present?
      apps.each { |app| puts app.name }
    else
      puts client.error
      puts client.error_description
    end
  end
end
