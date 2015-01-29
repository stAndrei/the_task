class SubcontractorPayout < ActiveRecord::Base
  belongs_to :subcontractor
  belongs_to :job
end

