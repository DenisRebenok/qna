module UserVotable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def make_vote(user, value)
    ActiveRecord::Base.transaction do
      vote = votes.find_or_initialize_by(user: user)
      vote.update! value: value
      update_votes_rating
    end
  end

  def destroy_vote(user)
    ActiveRecord::Base.transaction do
      vote = votes.find_by(user: user)
      vote.destroy! if vote
      update_votes_rating
    end
  end

  protected

  def update_votes_rating
    update! votes_rating: votes.sum(:value)
  end
end