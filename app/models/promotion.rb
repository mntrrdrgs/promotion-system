class Promotion < ApplicationRecord
    belongs_to :user
    has_many :coupons, dependent: :destroy
    has_one :promotion_approval
    has_one :approver, through: :promotion_approval, source: :user

    validates :name, :code, :discount_rate, :coupon_quantity,
              :expiration_date, presence: true

    validates :name, :code, uniqueness: true

    def generate_coupons!
     return if coupons?
        (1..coupon_quantity).each do |number|
            coupons.create!(code: "#{code}-#{'%04d' % number}")
        end
    end

    #TODO: fazer testes para esse método
    def coupons?
        coupons.any?
    end

    def approved?
        promotion_approval.present?
    end

    def can_approve?(current_user)
        user != current_user
    end
end
