require_relative "discounter"

module App
  class PriceStrategy
    attr_reader :promos, :total

    def initialize(promos: [])
      @promos = promos
      @total = 0.0
    end

    def initialize_copy(source)
      super

      @discounter = Discounter.new(promos:)
      @total = 0.0
    end

    def update(action)
      @total += (action.added? ? 1 : -1) * action.item.product.price

      observe_for_discount(action)
    end

    def total_to_pay
      total + available_discount
    end

    private

    def observe_for_discount(action)
      discounter.observe(action)
    end

    def available_discount
      discounter.discount
    end

    def discounter
      @discounter ||= Discounter.new(promos:)
    end
  end
end
