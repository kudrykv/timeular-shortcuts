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
end
