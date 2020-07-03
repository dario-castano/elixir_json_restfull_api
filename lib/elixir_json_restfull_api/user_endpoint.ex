defmodule ElixirJsonRestfullApi.UserEndpoint do
  @moduledoc """
  User Model :
  ```
    {
      "username": "helabenkhalfallah",
      "password": "",
      "lastName": "ben khalfallah",
      "firstName": "hela",
      "email": "helabenkhalfallah@hotmail.fr",
    }
  ```

  User endpoints :
  - /users : get all users (GET)
  - /user-by-email : find user by email (POST)
  - /user-by-user-name : find user by username (POST)
  - /add-user : add a new user (POST)
  - /delete-user : delete an existing user (POST)
  - /update-user-email : update an existing user by email (POST)
  - /update-update-user-name : update an existing user by username (POST)

  """

  @doc """
    Plug provides Plug.Router to dispatch incoming requests based on the path and method.
    When the router is called, it will invoke the :match plug, represented by a match/2function responsible
    for finding a matching route, and then forward it to the :dispatch plug which will execute the matched code.

    Mongo :
    https://hexdocs.pm/mongodb/Mongo.html#update_one/5

    Enum :
    https://hexdocs.pm/elixir/Enum.html#into/2

    Example :
    https://tomjoro.github.io/2017-02-09-ecto3-mongodb-phoenix/
  """
  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)

  # responsible for matching routes
  plug(:match)

  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  # responsible for dispatching responses
  plug(:dispatch)

  get "/ping" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{response: "pong"}))
  end

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  # Get all users
  get "/users" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{response: "This a test message !"}))
  end


  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "Unknown request :( !")
  end
end
