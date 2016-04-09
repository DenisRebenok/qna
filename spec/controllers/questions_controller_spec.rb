require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:foreign_question) { create :question }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'created question belongs to user who have created it' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user).to eq @user
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context 'Authenticated user' do
      before { sign_in(user) }

      it "assigns the requested question to @question" do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it "does not change foreign question attributes" do
        patch :update, id: foreign_question, question: { title: 'new title', body: 'new body' }, format: :js
        foreign_question.reload
        expect(foreign_question.title).to_not eq 'new title'
        expect(foreign_question.body).to_not eq 'new body'
      end

      it "render update template" do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Non-authenticated user' do
      it 'does not change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context 'Author can delete his own question' do
      let!(:question) { create(:question, user: @user) }

      it 'User deletes his own question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it "redirects to index view and display notice message" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to eq 'Your question successfully deleted.'
      end
    end

    context 'Non author can not delete question' do
      let(:another_user) { create(:user) }
      let!(:question) { create(:question, user: another_user) }

      it 'User can not delete not his question' do
         expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects to index view and display alert message" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
        expect(flash[:alert]).to eq 'You have not rights to delete this question!'
      end
    end
  end
end
