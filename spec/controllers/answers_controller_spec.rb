require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }


  describe "GET #index" do
    let(:answers) { create_list(:answer, 2, :question) }

    before { get :index, question_id: question }

    it "populates an array of all answers for question" do
      expect(assigns(:answers)).to match_array question.answers
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    let(:answer) { create :answer }
    before { get :show, id: answer }

    it "assigns the requested answer to @answer" do
      expect(assigns :answer).to eq(answer)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do
    let(:answer) { create :answer }
    before { get :edit, id: answer }

    it "assigns the requested answer to @answer" do
      expect(assigns :answer).to eq(answer)
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid atributes" do
      let(:qna_params) { {answer: attributes_for(:answer), question_id: question} }

      it "assigns the requested answer to @answer" do
        post :create, qna_params
        expect(assigns :answer).to eq(question.answers.first)
      end

      it 'saves the new answer in the database' do
        expect { post :create, qna_params }.to change(question.answers, :count).by(1)
      end

      it "redirects to question" do
        post :create, qna_params
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end

    context "with invalid attributes" do
      let(:qna_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

      it 'does not save the answer' do
        expect { post :create, qna_params }.to_not change(Answer, :count)
      end

      it "redirects to question" do
        post :create, qna_params
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end
  end

  describe "PATCH #update" do
    let(:answer) { create :answer }

    it "assigns the requested answer to @answer" do
      patch :update, id: answer, answer: attributes_for(:answer)
      expect(assigns(:answer)).to eq(answer)
    end

    context "valid attributes" do
      before do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
      end

      it "changes answer attributes" do
        expect(answer.body).to eq 'new body'
      end

      it "redirects to the updated answer" do
        expect(response).to redirect_to :answer
      end
    end

    context "invalid attributes" do
      before do
        patch :update, id: answer,  answer: attributes_for(:invalid_answer)
        answer.reload
      end

      it "does not change answer attributes" do
        expect(answer.body).to_not eq nil
      end

      it "re-render edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer) { create :answer }

    it "assigns the requested answer to @answer" do
      delete :destroy, id: answer
      expect(assigns(:answer)).to eq(answer)
    end


    it "deletes answer" do
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it "redirects to index view" do
      delete :destroy, id: answer
      expect(response).to redirect_to question_answers_path(answer.question)
    end
  end

end
