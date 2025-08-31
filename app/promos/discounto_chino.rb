# Description:
#   The CTO is a coffee addict. If you buy 3 or more coffees,
#   the price of all coffees should drop to two thirds of the original price.

require_relative "base"

module App
  module Promos
    class DiscountoChino < Base
      PROMO_COEFFICIENT = 0.75.freeze
      MINIMUM_QUANTITY = 3.freeze

      def observe(action)
        code = action.item.product.code

        return unless code == Product::CF_1

        @analysis[:"#{code}_quantity"] += action.added? ? 1 : -1
      end

      private

      def promo_analysis_template
        {
          CF1_quantity: 0
        }
      end

      def calculate_discount
        quantity = @analysis[:CF1_quantity]

        return 0.0 if quantity < MINIMUM_QUANTITY

        quantity * catalogue.find(Product::CF_1).price * (PROMO_COEFFICIENT - 1)
      end
    end
  end
end
