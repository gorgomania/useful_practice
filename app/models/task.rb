class Task < ApplicationRecord
  belongs_to :project
  enum :status, [ :todo, :inprogress, :intesting, :rejected, :done ]
end
