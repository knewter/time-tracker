defmodule TimeTrackerBackend.UserTest do
  use TimeTrackerBackend.ModelCase

  alias TimeTrackerBackend.{User}

  test "changeset with valid attributes" do
    changeset = build(:user) |> User.changeset(%{})
    assert changeset.valid?
  end

  describe "validations" do
    # We describe each field that we are validating and the corresponding
    # message we expect to see if the field is missing.
    fields = [
      {:name, "can't be blank"},
      {:gender, "can't be blank"},
      {:email, "can't be blank"},
      {:username, "can't be blank"},
      {:password, "can't be blank"},
      {:is_superuser, "can't be blank"},
      {:is_active, "can't be blank"},
      {:avatar, "can't be blank"}
    ]

    for {field, message} <- fields do
      @field field
      @message message
      test "is invalid without the #{field} field" do
        changeset = build(:user) |> User.changeset(%{@field => nil})
        refute changeset.valid?
        assert changeset.errors == [{@field, {@message, []}}]
      end
    end
  end
end
