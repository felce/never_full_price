module App
  class Discounter
    attr_reader :promos

    def initialize(promos:)
      @promos = promos.map(&:new)
    end

    def observe(action)
      promos.each { |promo| promo.observe(action) }
    end

    def discount
      promos.sum(&:discount)
    end
  end
end
