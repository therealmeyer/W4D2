class Cat < ApplicationRecord
  validates :name, :color, :sex, :description, :birth_date, presence: true
  validate :inclusion
  
  COLORS = ["brown", "black", "white", "tabby", "orange", "other"]
  
  has_many :cat_rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :CatRentalRequest,
  dependent: :destroy
  
  def inclusion
    unless COLORS.include?(self.color)
      errors[:color] << "is not a valid color."
    end
    unless self.sex == "M" || self.sex == "F"
      errors[:sex] << "is not a valid sex."
    end
  end
  
  
end 