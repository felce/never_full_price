# Description:
#   The CEO is a big fan of buy-one-get-one-free offers and of green tea.
#   He wants us to add a rule to do this.

require_relative "base"

module App
  module Promos
    class GreenTeaOnMe < Base
      def observe(action)
        code = action.item.product.code

        return unless code == Product::GR_1

        @analysis[:"#{code}_quantity"] += action.added? ? 1 : -1
      end

      private

      def promo_analysis_template
        {
          GR1_quantity: 0
        }
      end

      MINIMUM_QUANTITY = 2.freeze

      def calculate_discount
        quantity = @analysis[:GR1_quantity]

        return 0.0 if quantity < MINIMUM_QUANTITY

        - catalogue.find(Product::GR_1).price * (quantity / 2)
      end
    end
  end
end
