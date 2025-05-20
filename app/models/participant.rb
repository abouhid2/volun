class Participant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event
  belongs_to :car, optional: true
  
  validates :event_id, presence: true
  validates :status, presence: true, inclusion: { in: ['going', 'not_going', 'maybe'] }
  validates :name, presence: true, if: -> { user_id.blank? }
  
  validate :car_belongs_to_event
  validate :car_has_available_seats, if: -> { car_id.present? }
  
  private
  
  def car_belongs_to_event
    return unless car_id.present? && car.present?
    errors.add(:car_id, 'must belong to the same event') unless car.event_id == event_id
  end
  
  def car_has_available_seats
    return unless car.present?
    errors.add(:car_id, 'has no available seats') if car.available_seats <= 0
  end
end
