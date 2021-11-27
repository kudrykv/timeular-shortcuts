# frozen_string_literal: true

class TimeEntry < BasicHash
  def activities=(list)
    @activities = list
    @activity = list.find { |act| @item['activityId'] == act['id'] }
  end

  def describe
    "You're tracking #{activity_name.downcase} activity,#{describe_note} for #{human_duration}."
  end

  def started_at
    @started_at ||= Time.parse("#{@item['startedAt']}Z")
  end

  def prepend_tags(encoded_tags)
    encoded_tags = encoded_tags.reject { |t| note_text&.include? t }
    return note_text if encoded_tags.empty?

    encoded_tags.push(note_text).compact.join(' ')
  end

  def extract_tags_to_string
    return unless note_text

    note_text.scan(/<{{\|t\|\d+\|}}>/)&.join(' ')
  end

  private

  def activity_name
    @activity && @activity['name'] || @item['activityId']
  end

  def describe_note
    return unless note_text

    @item['note']['tags'].reduce(" #{note_text}") do |note, tag|
      note.gsub("<{{|t|#{tag['id']}|}}>", "##{tag['label']}")
    end
  end

  def human_duration
    ActiveSupport::Duration.build((Time.now.utc - started_at).floor).inspect
  end

  def note_text
    @item['note']['text']
  end
end
