class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @received_messages = current_user.received_messages.includes(:sender, :property).order(created_at: :desc)
    @sent_messages = current_user.sent_messages.includes(:receiver, :property).order(created_at: :desc)
  end

  def new
    @property = Property.find(params[:property_id])
    @message = Message.new
  end

  def create
    @property = Property.find(params[:property_id])
    @message = current_user.sent_messages.build(message_params)
    @message.property = @property
    @message.receiver = @property.user

    if @message.save
      redirect_to @property, notice: "Message sent successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = Message.find(params[:id])
    unless @message.sender == current_user || @message.receiver == current_user
      redirect_to messages_path, alert: "You are not authorized to view this message."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :subject)
  end
end


