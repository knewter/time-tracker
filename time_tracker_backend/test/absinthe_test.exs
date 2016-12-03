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

  test "getting a single user by ID" do
    {:ok, josh} = create_user(%{name: "Josh Adams"})

    query =
      """
      {
        user(id: "#{josh.id}") {
          id
          name
        }
      }
      """

    expectation = %{"id" => "#{josh.id}", "name" => josh.name}

    assert_graphql(query, %{"user" => expectation})
  end

  test "inserting a user using the create_user mutation" do
    query =
      """
      mutation CreateUser {
        user(
          name:"Josh",
          avatar:"nope",
          gender:"male",
          email:"josh@dailydrip.com",
          username:"knewter"
          password:"secret"
        ){
          id
        }
      }
      """

    result = evaluate_graphql(query)
    new_user = Repo.all(User) |> hd
    assert result == {:ok, %{data: %{"user" => %{"id" => "#{new_user.id}"}}}}
  end

  defp create_user(args) do
    %User{password: "secret"}
      |> Map.merge(args)
      |> Repo.insert
  end

  defp assert_graphql(query, expectation) do
    result = evaluate_graphql(query)

    assert result == {:ok, %{data: expectation}}
  end

  defp evaluate_graphql(query) do
    Absinthe.run(query, TimeTrackerBackend.Schema)
  end
end
