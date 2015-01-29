class Client < ActiveRecord::Base
  has_many :invoices
  has_many :jobs
end
