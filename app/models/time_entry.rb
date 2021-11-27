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
