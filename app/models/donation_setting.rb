class DonationSetting < ApplicationRecord
  belongs_to :event

  validates :event_id, presence: true, uniqueness: true
  validates :types, presence: true
  validates :units, presence: true

  def self.default_types
    [
      'Bebida',
      'Comida',
      'Ração',
      'Limpeza',
      'Medicamentos',
      'Roupas',
      'Kit',
      'Outros'
    ]
  end

  def self.default_units
    [
      'kg',
      'g',
      'l',
      'ml',
      'unidades',
      'caixas',
      'sacos'
    ]
  end
end 