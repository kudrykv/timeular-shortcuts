# frozen_string_literal: true

class BasicHash
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def method_missing(symbol, *args)
    @item.send(symbol, *args)
  end

  def respond_to_missing?(*args)
    @item.respond_to_missing?(*args)
  end
end
