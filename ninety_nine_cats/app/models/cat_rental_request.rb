class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validate :inclusion
  validate :overlapping_approved_requests
  validate :dates_conflict
  
  STATUS = ['APPROVED', 'PENDING', 'DENIED']
      
  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat
  
  def dates_conflict
    if start_date > end_date
      errors[:start_date] << "must be before end date"
    end 
  end 
  
  def inclusion
    unless STATUS.include?(self.status)
      errors[:status] << 'is not a valid status!'
    end
  end
  
  def overlapping_requests
    CatRentalRequest
      .where('? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date', self.start_date, self.end_date) 
      .where('cat_id = ?', self.cat_id)
  end 
  
  def overlapping_approved_requests
    if overlapping_requests.where("status = 'APPROVED'").length > 0
      errors[:date] << 'overlaps with an existing rental request!'
    end
  end 
  
  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end 
  
  def approve!
    self.status = 'APPROVED'
    self.save
    overlapping_pending_requests.each do |request|
      request.status = 'DENIED'
    end  
  end 
  
  def pending?
    self.status == 'PENDING'
  end 
    
  def deny!
    self.status = 'DENIED'
  end
  
end