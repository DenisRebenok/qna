require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:foreign_answer) { create(:answer, question: question) }

  describe "POST #create" do
    before { sign_in(user) }

    context "with valid atributes" do
      let(:qna_params) { {answer: attributes_for(:answer), question_id: question, format: :js } }

      it "assigns the requested answer to @answer" do
        post :create, qna_params
        expect(assigns :answer).to eq(question.answers.last)
      end

      it 'saves the new answer in the database' do
        expect { post :create, qna_params }.to change(question.answers, :count).by(1)
      end

      it 'created answer belongs to user who have created it' do
        post :create, qna_params
        expect(assigns(:answer).user).to eq user
      end

      it "render create template" do
        post :create, qna_params
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      let(:qna_params) { { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

      it 'does not save the answer' do
        expect { post :create, qna_params }.to_not change(Answer, :count)
      end

      it "render create template" do
        post :create, qna_params
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    context 'Authenticated user' do
      before { sign_in(user) }

      it "assigns the requested answer to @answer" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it "assigns the question" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it "changes answer attributes" do
        patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it "does not change foreign answer attributes" do
        patch :update, id: foreign_answer, answer: { body: 'new body' }, format: :js
        foreign_answer.reload
        expect(foreign_answer.body).to_not eq 'new body'
      end

      it "render update template" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Non-authenticated user' do
      it 'does not change answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in(user) }

    context 'Author' do
      it 'deletes answer from database' do
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non author' do
      it "can't delete foreign answer" do
        expect { delete :destroy, id: foreign_answer, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, id: foreign_answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    let(:foreign_question) { create(:question) }
    let(:other_answer) { create(:answer, question: foreign_question) }

    context 'Authenticated user' do
      before { sign_in(user) }

      it 'set best answer' do
        patch :best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render best template' do
        patch :best, id: answer, format: :js
        expect(response).to render_template :best
      end

      it "doesn't set best answer for foreign question" do
        patch :best, id: other_answer, format: :js
        other_answer.reload
        expect(other_answer.best).to eq false
      end
    end

    context 'Unauthenticated user' do
      it "doesn't set best answer for foreign question" do
        patch :best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
