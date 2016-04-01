require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question }
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

    context 'Author can delete his own answer' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer from database' do
        expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
      end

      it "redirects to question show view and display notice message" do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
        expect(flash[:notice]).to eq 'Your answer successfully deleted.'
      end
    end

    context 'Non author can not delete answer' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: another_user) }

      it 'User can not delete not his answer' do
        expect { delete :destroy, question_id: question, id: answer }.to_not change(Answer, :count)
      end

      it "redirects to question show view and display alert message" do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
        expect(flash[:alert]).to eq 'You have not rights to delete this answer!'
      end
    end
  end
end
