class MessagesController < ApplicationController
    before_filter :authenticate_user_from_token!
    before_filter :authenticate_user!

	# swagger_controller :users, "Messages Management"
	# swagger_api :index do
	# 	summary "Get the last 5 messages in the area specified"
	# 	param :form, :latitude, :string, :required
	# 	param :form, :longitude, :string, :required
	# end
 #  swagger_api :create do
 #    summary "Create a new message"
 #    param :form, 'message[latitude]', :float, :required
 #    param :form, 'message[longitude]', :float, :required
 #    param :form, 'message[body]', :string, :required
 #    param :form, 'message[channel_id]', :integer, :optional
 #  end
 #  swagger_api :show do
 #    summary "Get the information of a specific message"
 #    param :path, :id, :integer, :required
 #  end

  def index
    # @messages = Message.message_in_area(params[:latitude], params[:longitude], current_user.message_zone).main_information
	  @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.find params[:id]
    render json: @message
  end

  def create
    channel = Channel.find params[:channel_id]
    @message = channel.messages.create(message_params.merge(author: current_user))
    WebsocketRails["channel_#{channel.id}"].trigger :new_message, MessageSerializer.new(@message).as_json
    render json: @message and return
  end

  def update
    @message = Message.find params[:id]
    if @message.author == current_user
      @message.update_attributes message_params
      render json: @message
    else
      render text: "Unauthorized", status: 401
    end
  end

  private
  def message_params
    params.require(:message).permit :latitude, :longitude, :body, :channel_id
  end
end
