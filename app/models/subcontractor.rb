class Subcontractor < ActiveRecord::Base
  has_many :jobs
  has_many :subcontractor_payouts
end

