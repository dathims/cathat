WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  subscribe :client_connected, :to => ChatController, :with_method => :connect
  subscribe :client_disconnected, :to => ChatController, :with_method => :disconnect
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
      # subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  subscribe :message_received, to: ChatController, with_method: :message_received
  subscribe :subscribe_private, :to => ChatController, :with_method => :authorize_channels
  subscribe :create_user_channel, :to => ChatController, :with_method => :create_user_channel
  subscribe :private_message, :to => ChatController, :with_method => :private_message
end
