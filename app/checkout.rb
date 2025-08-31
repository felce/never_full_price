require_relative "basket"
require_relative "catalogue"

module App
  class Checkout
    attr_reader :basket, :price_strategy

    def initialize(price_strategy:)
      @price_strategy = price_strategy.dup
      @basket = Basket.new.tap do |basket|
        basket.add_observer(@price_strategy)
      end
    end

    def scan(code)
      basket.add(Catalogue.instance.find(code))
    end

    def remove(code)
      basket.remove(Catalogue.instance.find(code))
    end

    def total
      price_strategy.total_to_pay
    end
  end
end
