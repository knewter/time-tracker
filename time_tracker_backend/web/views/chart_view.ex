defmodule TimeTrackerBackend.ChartView do
  use TimeTrackerBackend.Web, :view

  def render("index.json", %{data: data}) do
    %{data: data}
  end
end
