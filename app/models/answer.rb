class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :question_id, :user_id, :body, presence: true

  default_scope { order(best: :desc) }

  def best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
