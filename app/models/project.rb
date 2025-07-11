class Project < ApplicationRecord
  belongs_to :user
  has_many :task
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
end
