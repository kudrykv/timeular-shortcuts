# frozen_string_literal: true

class TimeularClient
  def initialize(token)
    @token = token
    @domain = 'https://api.timeular.com/api/v3'
    @format = '%Y-%m-%dT%H:%M:%S.000'
  end

  def current_tracking
    return unless (ct = get('/tracking')['currentTracking'])

    TimeEntry.new(ct)
  end

  def get_active_activities
    get_activities['activities'].map { |act| Activity.new(act) }
  end

  def start_tracking(id)
    post("/tracking/#{id}/start", json: { startedAt: now })
  end

  def stop_tracking
    post('/tracking/stop', json: { stoppedAt: now })
  rescue StandardError => e
    return if e.message.include? 'is not at least 1 minute'

    raise e
  end

  def tags
    get('/tags-and-mentions')['tags'].map { |t| Tag.new(t) }
  end

  def update_note(note)
    patch('/tracking', json: { note: { text: note } })
  end

  private

  def get_activities
    get('/activities')
  end

  def get(uri)
    get_json(auth.get(@domain + uri))
  end

  def post(uri, *args)
    get_json(auth.post(@domain + uri, *args))
  end

  def patch(uri, *args)
    get_json(auth.patch(@domain + uri, *args))
  end

  def get_json(result)
    raise result.body if result.status >= 400

    JSON.parse(result.body)
  end

  def auth
    HTTP.auth("Bearer #{@token}")
  end

  def now
    Time.now.utc.strftime(@format)
  end
end
