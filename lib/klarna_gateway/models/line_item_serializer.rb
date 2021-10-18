module KlarnaGateway
  class LineItemSerializer
    attr_reader :line_item, :strategy


    def initialize(line_item, strategy)
      @line_item = line_item
      @strategy = case strategy
                  when Symbol, String then strategy_for_region(strategy)
                  else strategy
                  end
    end

    # TODO: clarify what amounts exactly should be used
    def to_hash
      strategy.adjust_with(line_item) do
        {
          reference: line_item.sku,
          name: line_item.name,
          quantity: line_item.quantity,
          # Minor units. Includes tax, excludes discount.
          unit_price: unit_price,
          # tax rate, e.g. 500 for 5.00%
          tax_rate: line_item_tax_rate,
          # Includes tax and discount. Must match (quantity * unit_price) - total_discount_amount within ±quantity
          total_amount: total_amount,
          # Must be within ±1 of total_amount - total_amount * 10000 / (10000 + tax_rate). Negative when type is discount
          total_tax_amount: total_tax_amount,
          image_url: image_url,
          product_url: product_url
        }
      end
    end

    private

    def line_item_tax_rate
      # TODO: should we just calculate this?
      tax_rate = line_item.adjustments.tax.inject(0) { |total, tax| total + tax.source.amount }
      (10000 * tax_rate).to_i
    end

    def total_amount
      display_final_amount = Spree::Money.new(line_item.final_amount, { currency: line_item.currency })
      display_final_amount.cents
    end

    def total_tax_amount
      pre_tax_amount = line_item.discounted_amount - line_item.included_tax_total
      display_pre_tax_amount = Spree::Money.new(pre_tax_amount, { currency: line_item.currency })
      total_amount - display_pre_tax_amount.cents
    end

    def unit_price
      line_item.single_money.cents + (total_tax_amount / line_item.quantity).floor
    end

    def image_url
      return 'https://d3cctxpeul304k.cloudfront.net/variants/xbvpnduqmajlz2wch46whr90c87l/8cb5757b5927b5c3237adba833e86c26f16bb518e581e4f7778328724fea042a'
      image = line_item.variant.images.first

      return unless image.present?
      host = ActionController::Base.asset_host || store.url.to_s
      begin
        #scheme = "http://" unless host.to_s.match(/^https?:\/\//)
        #uri = URI::parse("#{scheme}#{host.sub(/\/$/, '')}#{image.attachment.url}")
      rescue URI::InvalidURIError => e
        return nil
      end
      uri.to_s
    end

    def host
      host = ActionController::Base.asset_host || Spree::Store.current.url
      host.match(/^http:/) ? host : "http://#{host}"
    end

    def product_url
      Spree::Core::Engine.routes.url_helpers.product_url(line_item.variant, host: store.url.to_s.chop) if store.url.present?
    end

    def strategy_for_region(region)
      case region.downcase.to_sym
        when :us then AmountCalculators::US::LineItemCalculator.new
        else AmountCalculators::UK::LineItemCalculator.new
        end
    end

    def store
      Spree::Store.current
    end
  end
end
