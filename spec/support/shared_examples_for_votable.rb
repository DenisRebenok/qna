RSpec.shared_examples_for 'user_votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let (:object) { create(described_class.to_s.underscore) }
  let (:user) { create(:user) }
  let (:another_user) { create(:user) }
  let (:another_user2) { create(:user) }
  let (:another_user3) { create(:user) }
  let (:another_user4) { create(:user) }

  before do
    object.make_vote(user, 1)
    object.make_vote(another_user, 1)
    object.make_vote(another_user2, 1)
    object.make_vote(another_user3, -1)
    object.make_vote(another_user4, -1)
  end

  describe 'make vote' do
    it 'make vote' do
      expect(object.votes.count).to eq(5)
    end

    it 'count and store rating to object' do
      expect(object.votes_rating).to eq(1)
    end
  end

  describe 'destroy vote' do
    before { object.destroy_vote(user) }

    it 'destroy vote' do
      expect(object.votes.count).to eq(4)
    end

    it 'recount store rating to object' do
      expect(object.votes_rating).to eq(0)
    end
  end

  describe 'voted?' do
    it 'return true if user voted' do
      expect(user.voted?(object)).to be_truthy
    end
  end
end