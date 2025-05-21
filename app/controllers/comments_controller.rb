class CommentsController < ApplicationController
  skip_before_action :authenticate_user

  before_action :set_event
  before_action :set_comment, only: [:update, :destroy]

  def index
    @comments = @event.comments.includes(:user).order(created_at: :desc)
    render json: @comments.as_json(include: { user: { only: [:id, :name] } })
  end

  def create
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user if current_user

    if @comment.save
      render json: @comment.as_json(include: { user: { only: [:id, :name] } }), status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    return head :unauthorized unless current_user
    return head :forbidden unless @comment.user_id == current_user.id

    if @comment.update(comment_params)
      render json: @comment.as_json(include: { user: { only: [:id, :name] } })
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    return head :unauthorized unless current_user
    return head :forbidden unless @comment.user_id == current_user.id

    @comment.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end 