RSpec.shared_examples_for 'voting' do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let (:object) { create(described_class.controller_name.classify.downcase.to_sym, user: another_user) }
  let (:user_object) { create(described_class.controller_name.classify.downcase.to_sym, user: user) }

  before { sign_in(user) }

  describe 'PATCH #vote_up' do
    it 'assign to @votable_object votable object' do
      patch :vote_up, id: object, format: :json

      expect(assigns(:votable_object)).to eq object
    end

    it 'can vote up for question' do
      expect { patch :vote_up, id: object, format: :json }.to change(object.votes, :count).by(1)
    end

    it 'change question vote rating' do
      patch :vote_up, id: object, format: :json
      object.reload
      expect(object.votes_rating).to eq 1
    end

    it 'cannot vote up own record' do
      expect { patch :vote_up, id: user_object, format: :json }.not_to change(user_object.votes, :count)
    end

    it 'render json error if vote own record' do
      json = %({"errors": "You cannot vote for own record"})

      patch :vote_up, id: user_object, format: :json

      expect(response.body).to be_json_eql json
    end

    it 'can vote only once' do
      expect { patch :vote_up, id: object, format: :json }.to change(object.votes, :count).by(1)
      expect { patch :vote_up, id: object, format: :json }.not_to change(object.votes, :count)
    end

    it 'respond json' do
      json = %({"object": #{object.id}, "rating": 1})

      patch :vote_up, id: object, format: :json

      expect(response.body).to be_json_eql json
    end
  end

  describe 'PATCH #vote_down' do
    it 'assign to @votable_object votable object' do
      patch :vote_down, id: object, format: :json

      expect(assigns(:votable_object)).to eq object
    end

    it 'can vote down for question' do
      expect { patch :vote_down, id: object, format: :json }.to change(object.votes, :count).by(1)
    end

    it 'change question vote rating' do
      patch :vote_down, id: object, format: :json
      object.reload

      expect(object.votes_rating).to eq -1
    end

    it 'cannot vote down own record' do
      expect { patch :vote_down, id: user_object, format: :json }.not_to change(user_object.votes, :count)
    end

    it 'render json error if vote own record' do
      json = %({"errors": "You cannot vote for own record"})

      patch :vote_down, id: user_object, format: :json

      expect(response.body).to be_json_eql json
    end

    it 'can vote only once' do
      expect { patch :vote_down, id: object, format: :json }.to change(object.votes, :count).by(1)
      expect { patch :vote_down, id: object, format: :json }.not_to change(object.votes, :count)
    end

    it 'respond json' do
      json = %({"object": #{object.id}, "rating": -1})

      patch :vote_down, id: object, format: :json

      expect(response.body).to be_json_eql json
    end
  end

  describe 'DELETE #unvote' do
    before { patch :vote_up, id: object, format: :json }

    it 'vote owner can delete his vote' do
      expect { delete :unvote, id: object, format: :json }.to change(object.votes, :count).by(-1)
    end

    it 'render json' do
      json = %({"object": #{object.id}, "rating": 0})

      delete :unvote, id: object, format: :json

      expect(response.body).to be_json_eql json
    end

    it 'render error if error' do
      json = %({"errors": "Not found"})

      delete :unvote, id: user_object, format: :json

      expect(response.body).to be_json_eql json
    end

    it 'response 404 if error' do
      delete :unvote, id: user_object, format: :json

      expect(response.status).to eq 404
    end
  end
end