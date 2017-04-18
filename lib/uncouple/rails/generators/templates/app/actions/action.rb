# <%= destination %>
class <%= name.classify %>Action < Uncouple::Action

  # Use attr_reader to access your instances outside the action
  # attr_reader :some_instance

  def perform
    # TODO: implement the core of your action here
  end

  # def success?
    # Overwrite me with a custom success check, or set @success in `perform`.
  # end

end
