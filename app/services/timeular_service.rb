# frozen_string_literal: true

class TimeularService
  def initialize(client)
    @client = client
  end

  def current_tracking
    return 'You are not tracking anything at the time.' unless (ct = @client.current_tracking)

    ct.activities = @client.get_active_activities
    ct.describe
  end

  def start_tracking(activity)
    return 'You need to specify an activity.' unless activity

    activities = @client.get_active_activities.filter { |act| act.name.downcase.include? activity.downcase }
    return "Cannot start as found multiple activities: #{activities.map(&:name).join(', ')}." if activities.length > 1
    return "I could not find #{activity} activity." if activities.empty?

    @client.stop_tracking if @client.current_tracking

    @client.start_tracking activities.first.id
    'Done.'
  end
end
