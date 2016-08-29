defmodule TimeTrackerBackend.ProjectView do
  use TimeTrackerBackend.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, TimeTrackerBackend.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, TimeTrackerBackend.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name}
  end
end
