class Event < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :entity
  belongs_to :user
  has_many :participants
  has_many :cars
  has_many :users, through: :participants
  has_many :donations
  has_many :inventory_transactions
  has_one :donation_setting, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true
  
  def available_seats
    cars.sum(:seats) - participants.where.not(car_id: nil).count
  end
  
  def total_donations_by_type(type)
    donations.total_by_type(id, type)
  end
  
  def total_participants
    participants.count
  end

  def total_cars
    cars.count
  end

  def total_donations
    donations.count
  end

  after_create :create_default_donation_settings

  private

  def create_default_donation_settings
    create_donation_setting(
      types: DonationSetting.default_types,
      units: DonationSetting.default_units
    )
  end
end
