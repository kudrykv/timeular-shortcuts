# frozen_string_literal: true
class TimeularController < ApplicationController
  def tracking_status
    render json: svc.current_tracking
  rescue StandardError => msg
    render json: msg, status: 400
  end

  private

  def svc
    TimeularService.new(client)
  end

  def client
    TimeularClient.new(api_token)
  end

  def api_token
    raise 'You need to specify an Api-Token header.' unless (token = request.headers['Api-Token'])

    token
  end
end
