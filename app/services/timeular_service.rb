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

  def stop_tracking
    return 'You are not tracking anything at the time.' unless @client.current_tracking

    @client.stop_tracking
    'Done.'
  end

  def tags(tags)
    return 'You are not tracking anything at the time.' unless (ct = @client.current_tracking)

    remote_tags = @client.tags
    unknown_tags = tags.map { |t| remote_tags.find { |rt| rt.label == t } ? nil : t }.compact
    return "Tags #{unknown_tags.join(', ')} are unknown." unless unknown_tags.empty?

    encoded_tags = tags.map { |t| remote_tags.find { |rt| rt.label == t }.encode_for_note }.join(' ')

    note = ct.extract_note_to_string
    @client.update_note("#{encoded_tags} #{note}")
    'Done.'
  end

  def add_tags(tags)
    return 'You are not tracking anything at the time.' unless (ct = @client.current_tracking)

    remote_tags = @client.tags
    unknown_tags = tags.map { |t| remote_tags.find { |rt| rt.label == t } ? nil : t }.compact
    return "Tags #{unknown_tags.join(', ')} are unknown." unless unknown_tags.empty?

    encoded_tags = tags.map { |t| remote_tags.find { |rt| rt.label == t }.encode_for_note }

    @client.update_note(ct.prepend_tags(encoded_tags))
    'Done.'
  end

  def comment(msg)
    return 'You did not specify your comment.' if msg.empty?
    return 'You are not tracking anything at the time.' unless (ct = @client.current_tracking)

    note = [ct.extract_tags_to_string, msg].compact.join(' ')
    @client.update_note(note)
    'Done.'
  end

  def activities
    @client.get_active_activities.map(&:name)
  end
end
