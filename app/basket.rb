require "observer"

module App
  class Basket
    include Observable

    BasketItem = Struct.new(:product, :quantity)
    BasketAction = Struct.new(:added?, :item)

    attr_reader :items

    def initialize
      @items = {}
    end

    def add(product)
      items[product.code] ||= BasketItem.new(product, 0)
      items[product.code].quantity += 1

      changed
      notify_observers(BasketAction.new(true, items[product.code]))
    end

    def remove(product)
      items[product.code].tap do |item|
        return if item.nil?

        item.quantity -= 1

        changed
        notify_observers(BasketAction.new(false, item))

        items.delete(product.code) if item.quantity.zero?
      end
    end
  end
end
