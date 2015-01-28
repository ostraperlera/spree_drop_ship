module Spree
  Variant.class_eval do

    has_many :suppliers, through: :supplier_variants
    has_many :supplier_variants

    before_create :populate_for_suppliers

    private

    durably_decorate :create_stock_items, mode: 'soft', sha: '40a37fdea4f3d8a1fe774911a603c013862545f5' do
      StockLocation.all.each do |stock_location|
        if stock_location.supplier_id.blank? || self.suppliers.pluck(:id).include?(stock_location.supplier_id)
          stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
        end
      end
    end

    def populate_for_suppliers
      self.suppliers = self.product.suppliers
    end

  end
end
