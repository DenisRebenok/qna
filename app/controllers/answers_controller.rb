class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def show
  end

  # def new
  #   @answer = @question.answers.new
  # end

  def edit
  end

  def create
    @answer = current_user.answers.new(answers_params.merge(question: @question))
    msg = @answer.save ? 'Answer was successfully created.' : 'Error was happened when trying to save answer.'
    redirect_to @question, notice: msg
  end

  def update
    if @answer.update(answers_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:alert] = 'You have not rights to delete this answer!'
    end
    redirect_to @answer.question
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
