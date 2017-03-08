# CuratorConfirmable

Adds an email confirmation workflow to Curator.

NOTE: You'll need to configure an email adapter.

## Installation

  1. Add `curator_confirmable` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:curator_confirmable, "~> 0.1.0"}]
    end
    ```

  2. Run the install command

    ```elixir
    mix curator_confirmable.install
    ```

  3. Update `web/models/user.ex`

    ```elixir
    defmodule Auth.User do
      use Auth.Web, :model

      use CuratorConfirmable.Schema

      schema "users" do
        ...
        curator_confirmable_schema
        ...
      end
    end
    ```

  4. Update `web/router.ex`

    ```elixir
    scope "/", Auth do
      pipe_through [:browser]

      resources "/confirmations", ConfirmationController, only: [:new, :create, :edit]

      ...
    end

    pipeline :browser do
      ...

      plug Curator.Plug.LoadSession
      ...
      plug CuratorConfirmable.Plug
      ...
      plug Curator.Plug.EnsureResourceOrNoSession, handler: <YourApp>.ErrorHandler
    end

    pipeline :authenticated_browser do
      ...

      plug Curator.Plug.LoadSession
      ...
      plug CuratorConfirmable.Plug
      ...
      plug Curator.Plug.EnsureResourceAndSession, handler: <YourApp>.ErrorHandler
    end
    ```

  5. Update `lib/<otp_app>/curator_hooks.ex`

    ```elixir
    def after_extension(conn, :registration, user) do
      conn
      |> put_flash(:info, "Account was successfully created. Check your email for a confirmation link")
      |> send_email(:confirmation, user)
      |> redirect(to: "/")
    end

    def after_extension(conn, :confirmation, _user) do
      conn
      |> put_flash(:info, "Account confirmed.")
      |> redirect(to: "/")
    end

    def send_email(conn, :confirmation, user) do
      {user, token} = CuratorConfirmable.set_confirmation_token!(user)

      url = confirmation_url(conn, :edit, token)

      # NOTE: Insert a call to your email library
      PhoenixCurator.Email.confirmation_email(user, url)
      |> PhoenixCurator.Mailer.deliver_now

      conn
    end
    ```

    NOTE: The email can be setup however you wish. If using [Bamboo](https://github.com/thoughtbot/bamboo) it could look something like this:

    ```elixir
    def confirmation_email(%{email: email}, url) do
      new_email
      |> to(email)
      |> from(@sender)
      |> subject("Welcome #{email}.")
      |> html_body("<strong>Click <a href=\"#{url}\">HERE</a> to confirm you account</strong>")
      |> text_body("visit the following URL to confirm you account: #{url}")
    end
    ```

  6. Update `test/supprt/session_helper.ex`

    ```elixir
    def create_user(user, attrs) do
      user
      |> PhoenixCurator.User.changeset(attrs)
      |> PhoenixCurator.User.password_changeset(%{password: "TEST_PASSWORD", password_confirmation: "TEST_PASSWORD"})
      |> Ecto.Changeset.change(confirmed_at: Timex.now)
      ...
      |> PhoenixCurator.Repo.insert!
    end
    ```

  7. Update `test/controllers/page_controller_test.exs`

    ```elixir
    test "visiting a secret page w/ a signed_in unconfirmed user", %{conn: conn} do
      user = User.changeset(%User{}, @user_attrs)
      |> User.password_changeset(%{password: "TEST_PASSWORD", password_confirmation: "TEST_PASSWORD"})
      #|> Ecto.Changeset.change(confirmed_at: Ecto.DateTime.utc)
      #|> User.approvable_changeset(%{approval_at: Ecto.DateTime.utc, approval_status: "approved", approver_id: 0})
      |> Auth.Repo.insert!

      conn = conn
      |> sign_in(user)
      |> get("/secret")

      assert Phoenix.Controller.get_flash(conn, :danger) == "Not Confirmed"
      assert Phoenix.ConnTest.redirected_to(conn) == session_path(conn, :new)
    end
    ```
