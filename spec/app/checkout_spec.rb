require "yaml"
require_relative "../../app/checkout"
require_relative "../../app/product"
require_relative "../../app/price_strategy"
require_relative "../../app/catalogue"
require_relative "../../app/promos/cmo_llection"
require_relative "../../app/promos/coo_berry"
require_relative "../../app/promos/discounto_chino"
require_relative "../../app/promos/green_tea_on_me"
require_relative "../../app/promos/lucky_patrick"

RSpec.shared_examples "price calculation" do
  it "calculates total price" do
    items.each do |item|
      add, code = %w[+ -].include?(item[0]) ? [item[0] == "+", item[1..-1]] : [true, item]

      add ? checkout.scan(code) : checkout.remove(code)
    end

    expect(checkout.total).to eq(expected)
  end
end

RSpec.describe App::Checkout do
  YAML.load_file(fixture_path("products.yml")).each do |product_data|
    attributes = product_data.transform_keys(&:to_sym)

    if attributes[:attributes]
      attributes[:attributes] = attributes[:attributes].transform_keys(&:to_sym)
    end

    App::Catalogue.instance.add(App::Product.new(**attributes))
  end

  let(:items) { [] }
  let(:price_strategy) { App::PriceStrategy.new(promos:) }
  subject(:checkout) { described_class.new(price_strategy:) }

  context "when there are no promo rules" do
    let(:promos) { [] }
    let(:items) { %w[GR1 CF1 CF1 GR1 GR1 SR1 SR1 CF1 CF1 SR1] }
    let(:expected) { 69.25 }

    it_behaves_like "price calculation"
  end

  context "when basket is empty" do
    let(:promos) { [] }
    let(:expected) { 0.0 }

    it_behaves_like "price calculation"
  end

  context "when there are no code in the catalogue" do
    let(:items) { %w[KT1] }
    let(:promos) { [] }

    it "raises an error" do
      expect { checkout.scan("KT1") }.to raise_error(App::Catalogue::ProductNotFound)
                                           .with_message("Product KT1 not found")
    end
  end

  context "with promo rules" do
    let(:promos) { [App::Promos::DiscountoChino,
                    App::Promos::GreenTeaOnMe,
                    App::Promos::CooBerry,
                    App::Promos::CmoLlection] }

    context "when there are GR1 in the basket" do
      let(:items) { %w[GR1] }
      let(:expected) { 3.11 }

      it_behaves_like "price calculation"
    end

    context "when GR1 is in the basket and then put away" do
      let(:items) { %w[GR1 -GR1] }
      let(:expected) { 0.0 }

      it_behaves_like "price calculation"
    end

    context "when there are GR1,SR1,GR1,GR1,CF1 in the basket" do
      let(:items) { %w[GR1 SR1 GR1 GR1 CF1] }
      let(:expected) { 22.45 }

      it_behaves_like "price calculation"
    end

    context "when there are GR1,GR1 in the basket" do
      let(:items) { %w[GR1 GR1] }
      let(:expected) { 3.11 }

      it_behaves_like "price calculation"
    end

    context "when there are SR1,SR1,GR1,SR1 in the basket" do
      let(:items) { %w[SR1 SR1 GR1 SR1] }
      let(:expected) { 16.61 }

      it_behaves_like "price calculation"
    end

    context "when there are plates in the basket" do
      context "when no collection in basket" do
        let(:items) { %w[PL1_W PL1_B PL1_G PL1_W] }
        let(:expected) { 24.00 }

        it_behaves_like "price calculation"
      end

      context "when there is collection in the basket" do
        let(:items) { %w[PL1_W PL1_G PL1_B PL1_R] }
        let(:expected) { 18.00 }

        it_behaves_like "price calculation"
      end

      context "when scanning and removing the green plate" do
        let(:items) { %w[PL1_W PL1_G PL1_B PL1_R -PL1_G PL1_B] }
        let(:expected) { 24.00 }

        it_behaves_like "price calculation"
      end

      context "when there is collection in the basket" do
        let(:items) { %w[PL1_R PL1_W PL1_G PL1_W PL1_B PL1_R ] }
        let(:expected) { 30.00 }

        it_behaves_like "price calculation"
      end

      context "when two collections in the basket" do
        let(:items) { %w[PL1_R PL1_W PL1_G PL1_W PL1_B PL1_B PL1_R PL1_G] }
        let(:expected) { 36.00 }

        it_behaves_like "price calculation"
      end
    end

    context "when St Patrick's Day promo is applied" do
      let(:promos) { [App::Promos::LuckyPatrick] }

      context "when there are no 3 green items in the basket" do
        let(:items) { %w[PL1_R PN1_G SB1_R SB1_G] }
        let(:expected) { 21.50 }

        it_behaves_like "price calculation"
      end

      context "when there are 3 green items in the basket" do
        context "when the cheapest one is pencil" do
          let(:items) { %w[PL1_R PN1_G SB1_R SB1_G PL1_G] }
          let(:expected) { 26.00 }

          it_behaves_like "price calculation"
        end

        context "when the cheapest one is plate" do
          let(:items) { %w[PL1_R PL1_G SB1_R SB1_G PL1_G] }
          let(:expected) { 30.30 }

          it_behaves_like "price calculation"
        end

        context "when the cheapest one was a pencil but removed" do
          let(:items) { %w[PL1_R PL1_G PN1_G SB1_R SB1_G PL1_G -PN1_G] }
          let(:expected) { 30.30 }

          it_behaves_like "price calculation"
        end
      end
    end
  end
end
