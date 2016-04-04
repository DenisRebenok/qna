class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  def create
    @answer = current_user.answers.new(answers_params.merge(question: @question))
    flash[:notice] = 'Answer was successfully created.' if @answer.save
  end

  def update
    @answer.update(answers_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    @answer.best! if current_user.author_of?(@answer.question)
    @answers = @answer.question.answers
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
