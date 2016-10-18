defmodule TimeTrackerBackend.Repo do
  use Ecto.Repo, otp_app: :time_tracker_backend
  use Scrivener, page_size: 10
end
