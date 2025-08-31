# Description:
#   On supermarket shelves, there are plates from The Firm in four different colors:
#   white, blue, red, and green.
#   The CMO noticed that shoppers mostly choose the white and blue plates,
#   while red and green remain unpopular.
#
#   To encourage balanced sales, the CMO suggests this rule:
#   If a customer buys one plate of each color (all four different colors),
#   they only pay the price of three - and the price of the Red plate is free.

require_relative "base"

module App
  module Promos
    class CmoLlection < Base
      OBSERVABLE_PRODUCTS = [Product::PL_1_W, Product::PL_1_B, Product::PL_1_R, Product::PL_1_G].freeze
      MINIMUM_QUANTITY = 3.freeze

      def observe(action)
        code = action.item.product.code

        return unless OBSERVABLE_PRODUCTS.include?(code)

        @analysis[:"#{code}_quantity"] += action.added? ? 1 : -1
      end

      private

      def promo_analysis_template
        {
          PL1_W_quantity: 0,
          PL1_B_quantity: 0,
          PL1_R_quantity: 0,
          PL1_G_quantity: 0
        }
      end

      def calculate_discount
        multiplier = @analysis.values.min

        return 0.0 if multiplier.zero?

        - multiplier * catalogue.find(Product::PL_1_R).price
      end
    end
  end
end
