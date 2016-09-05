defmodule TimeTrackerBackend.OrganizationView do
  use TimeTrackerBackend.Web, :view

  def render("index.json", %{organizations: organizations}) do
    %{data: render_many(organizations, TimeTrackerBackend.OrganizationView, "organization.json")}
  end

  def render("show.json", %{organization: organization}) do
    %{data: render_one(organization, TimeTrackerBackend.OrganizationView, "organization.json")}
  end

  def render("organization.json", %{organization: organization}) do
    %{id: organization.id,
      name: organization.name}
  end
end
