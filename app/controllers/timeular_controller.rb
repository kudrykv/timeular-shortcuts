# frozen_string_literal: true

class TimeularController < ApplicationController
  def tracking_status
    render json: svc.current_tracking
  rescue StandardError => e
    render json: e, status: 400
  end

  def start_tracking
    render json: svc.start_tracking(query_activity)
  rescue StandardError => e
    render json: e, status: 400
  end

  def stop_tracking
    render json: svc.stop_tracking
  rescue StandardError => e
    render json: e, status: 400
  end

  def tags
    render json: svc.tags(query_tags)
  rescue StandardError => e
    render json: e, status: 400
  end

  def add_tags
    render json: svc.add_tags(query_tags)
  rescue StandardError => e
    render json: e, status: 400
  end

  def comment
    render json: svc.comment(query_comment)
  rescue StandardError => e
    render json: e, status: 400
  end

  def activities
    render json: svc.activities
  rescue StandardError => e
    render json: e, status: 400
  end

  private

  def query_activity
    params[:activity]
  end

  def query_tags
    params[:tags_string].split(/,|\s|and/).map(&:downcase).map(&:strip).compact.reject(&:empty?)
  end

  def query_comment
    params[:comment]
  end

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
