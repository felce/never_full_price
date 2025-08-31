# Description:
#
#  If you buy 3 or more green items, the cheapest one will magically become free*
#  * if it's under £1.70 it will be free for this item,
#    or you'll get £1.70 off if it's over £1.70.

require_relative "base"

module App
  module Promos
    class LuckyPatrick < Base
      def observe(action)
        colour = action.item.product.attributes[:colour]

        return unless colour == OBSERVABLE_COLOUR

        if action.added?
          @analysis[:quantity] += 1
          @analysis[:prices] << action.item.product.price
        else
          @analysis[:quantity] -= 1
          @analysis[:prices].delete(action.item.product.price) if action.item.quantity.zero?
        end
      end

      private

      def promo_analysis_template
        {
          quantity: 0,
          prices: Set.new
        }
      end

      OBSERVABLE_COLOUR = "green"
      DISCOUNT_THRESHOLD = 1.70.freeze
      MINIMUM_QUANTITY = 3.freeze

      def calculate_discount
        return 0.0 if @analysis[:quantity] < MINIMUM_QUANTITY

        min_price = @analysis[:prices].min

        - (min_price <= DISCOUNT_THRESHOLD ? min_price : DISCOUNT_THRESHOLD)
      end
    end
  end
end
