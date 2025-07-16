class Task < ApplicationRecord
  belongs_to :project
  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id }
  state_machine :state, initial: :ToDo do
    event :inprogress do
      transition [ :ToDo, :Rejected ] => :InProgress
    end
    event :todo do
      transition InProgress: :ToDo
    end
    event :intesting do
      transition InProgress: :InTesting
    end
    event :done do
      transition InTesting: :Done
    end
    event :rejected do
      transition InTesting: :Rejected
    end
  end
end
