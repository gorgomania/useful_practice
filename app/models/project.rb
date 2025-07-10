class Project < ApplicationRecord
  belongs_to :user
  has_many :task
  validates :name, presence: true
  validates :name, uniqueness: true
end
