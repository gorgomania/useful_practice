class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  STATES = [ "To Do", "In Progress", "In Testing", "Rejected", "Done" ].freeze
  STATE_KEYS = %w[ToDo InProgress InTesting Rejected Done].freeze

  def tasks_by_state
    grouped = tasks.group_by(&:state)
    columns = STATE_KEYS.map { |s| grouped[s] || [] }
    size = columns.map(&:size).max.to_i
    size.times.flat_map { |i| columns.map { |col| col[i] } }
  end
end
