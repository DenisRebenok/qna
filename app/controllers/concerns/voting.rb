module Voting
  extend ActiveSupport::Concern

  included do
    before_action :load_vote, only: [:vote_up, :vote_down, :unvote]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def unvote
    if current_user.voted?(@votable_object)
      @votable_object.destroy_vote(current_user)
      render json: { object: @votable_object.id, rating: @votable_object.votes_rating }
    else
      render json: { errors: 'Not found' }, status: :not_found
    end
  end

  private

  def load_vote
    @votable_object = controller_name.classify.constantize.find(params[:id])
  end

  def vote(value)
    if current_user.author_of? @votable_object
      render json: { errors: 'You cannot vote for own record' }, status: :forbidden
    else
      @votable_object.make_vote(current_user, value)
      render json: { object: @votable_object.id, rating: @votable_object.votes_rating }
    end
  end
end