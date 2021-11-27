# frozen_string_literal: true

class Tag < BasicHash
  def id
    @item['id']
  end

  def label
    @item['label']
  end

  def encode_for_note
    "<{{|t|#{id}|}}>"
  end
end
