defimpl Poison.Encoder, for: TimeTrackerBackend.User do
  def encode(user, _) do
    %{ name: user.name } |> Poison.encode!
  end
end
