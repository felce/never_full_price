module App
  class Product
    attr_reader :code, :price, :attributes

    GR_1 = "GR1"
    SR_1 = "SR1"
    CF_1 = "CF1"
    PL_1_W = "PL1_W"
    PL_1_B = "PL1_B"
    PL_1_R = "PL1_R"
    PL_1_G = "PL1_G"
    SB_1_G = "SB1_G"
    SB_1_R = "SB1_R"
    SB_1_W = "SB1_W"
    PN_1_G = "PN1_G"
    PN_1_R = "PN1_R"
    PN_1_W = "PN1_W"

    def initialize(code:, name:, price:, attributes: {})
      @code = code
      @price = price
      @name = name
      @attributes = attributes
    end
  end
end
