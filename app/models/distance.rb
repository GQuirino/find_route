class Distance < ApplicationRecord
  belongs_to :map

  validates :origin, :destiny, presence: true
end
