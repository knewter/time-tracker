defmodule TimeTrackerBackend.AbsintheTest do
  use TimeTrackerBackend.ModelCase
  alias TimeTrackerBackend.User

  test "getting a list of users" do
    {:ok, josh} = create_user(%{name: "Josh Adams"})
    {:ok, adam} = create_user(%{name: "Adam Dill"})

    query =
      """
      {
        users{
          id
          name
        }
      }
      """

    expected_users =
      [
        %{"id" => "#{josh.id}", "name" => josh.name},
        %{"id" => "#{adam.id}", "name" => adam.name}
      ]

    assert_graphql(query, %{"users" => expected_users})
  end

  defp create_user(args) do
    %User{password: "secret"}
      |> Map.merge(args)
      |> Repo.insert
  end

  defp assert_graphql(query, expectation) do
    result = Absinthe.run(query, TimeTrackerBackend.Schema)

    assert result == {:ok, %{data: expectation}}
  end
end
