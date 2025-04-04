# frozen_string_literal: true

module Spree
  class UserGroup < Spree::Base
    has_many :users, class_name: Spree::UserClassHandle.new
    has_one :store, class_name: 'Spree::Store', foreign_key: 'default_user_group_id'
    belongs_to :price_list, class_name: 'Spree::PriceList', optional: true

    validates :group_name, presence: true
  end
end
