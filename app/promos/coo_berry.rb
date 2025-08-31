# Description:
#   The COO, though, likes low prices and wants people buying strawberries
#   to get a price discount for bulk purchases.
#   If you buy 3 or more strawberries, the price should drop to £4.50

require_relative "base"

module App
  module Promos
    class CooBerry < Base
      MINIMUM_QUANTITY = 3.freeze
      SR_PROMO_PRICE = 4.50.freeze

      def observe(action)
        code = action.item.product.code

        return unless code == Product::SR_1

        @analysis[:"#{code}_quantity"] += action.added? ? 1 : -1
      end

      private

      def promo_analysis_template
        {
          SR1_quantity: 0
        }
      end

      def calculate_discount
        quantity = @analysis[:SR1_quantity]

        return 0.0 if quantity < MINIMUM_QUANTITY

        quantity * (SR_PROMO_PRICE - catalogue.find(Product::SR_1).price)
      end
    end
  end
end
