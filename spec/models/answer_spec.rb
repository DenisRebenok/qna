require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }

  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }

  it_behaves_like 'attachable'

  describe '#best!' do
    let!(:question) { create(:question) }
    let!(:new_best_answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it "make answer best" do
      new_best_answer.best!
      new_best_answer.reload
      expect(new_best_answer.best).to eq true
    end

    it "set previous best answer's best value to false" do
      new_best_answer.best!
      best_answer.reload
      expect(best_answer.best).to eq false
    end
  end
end
