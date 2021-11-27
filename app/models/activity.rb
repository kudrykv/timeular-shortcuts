# frozen_string_literal: true

class Activity < BasicHash
  def id
    @item['id']
  end

  def name
    @item['name']
  end
end
