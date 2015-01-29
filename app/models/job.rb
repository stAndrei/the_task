class Job < ActiveRecord::Base
  belongs_to :client
  belongs_to :subcontractor

  has_one :invoice
  has_one :subcontractor_payout

  STATUSES = %w(new accepted rejected done)
end

