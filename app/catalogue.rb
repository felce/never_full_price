require "singleton"
require "forwardable"
require_relative "product"

module App
  class Catalogue
    class Error < StandardError; end
    class ProductNotFound < Error; end

    extend Forwardable
    include Singleton

    def_delegators :@data, :[], :each

    def initialize
      @data = {}
    end

    def add(product)
      @data[product.code] = product
    end

    def find(code)
      @data[code] || raise(ProductNotFound, "Product #{code} not found")
    end
  end
end
