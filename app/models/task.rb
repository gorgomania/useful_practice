class Task < ApplicationRecord
  belongs_to :project
  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id }
end
