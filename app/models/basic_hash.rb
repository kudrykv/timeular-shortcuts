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

  def respond_to?(*args)
    @item.respond_to?(*args)
  end

  def ==(obj)
    return false unless obj.item

    @item.keys do |key|
      return false if @item[key] != obj.item[key]
    end

    true
  end
end
