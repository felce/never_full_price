require_relative "../../app/catalogue"

module App
  module Promos
    class Base
      def initialize
        @analysis = promo_analysis_template
      end

      def observe(_item)
        raise NotImplementedError
      end

      def discount
        calculate_discount
      end

      private

      def promo_analysis_template
        raise NotImplementedError
      end

      def calculate_discount
        raise NotImplementedError
      end

      def catalogue
        Catalogue.instance
      end
    end
  end
end
