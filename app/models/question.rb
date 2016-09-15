class Question < ActiveRecord::Base
  include Attachable
  include UserVotable

  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true
end
