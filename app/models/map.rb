class Map < ApplicationRecord
  has_many :distances, dependent: :destroy

  accepts_nested_attributes_for :distances

  validates :name, presence: true
end
