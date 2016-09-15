class AddVotesRatingToQuestionAnswer < ActiveRecord::Migration
  def change
    add_column :questions, :votes_rating, :integer, :default => 0, index: true
    add_column :answers, :votes_rating, :integer, :default => 0, index: true
  end
end
