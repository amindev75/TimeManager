defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt  # Importer le module Bcrypt pour le hachage

  @roles %{employe: 0, manager: 1, admin: 2}
  @valid_roles Map.values(@roles)

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true  # Champ virtuel pour le mot de passe
    field :password_hash, :string
    field :role, :integer, default: @roles[:employe]

    has_many :workingtimes, TimeManager.TimeManagement.Workingtime, on_delete: :delete_all
    has_one :clock, TimeManager.TimeManagement.Clock, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])  # Assurez-vous que le mot de passe est requis
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_inclusion(:role, @valid_roles)
    |> put_password_hash()  # Hachage du mot de passe
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        # Hachage du mot de passe ici
        hashed_password = Bcrypt.hash_pwd_salt(password)  # Hachage du mot de passe avec le sel
        put_change(changeset, :password_hash, hashed_password)
    end
  end

  # Fonction pour vérifier si un mot de passe correspond à son hachage
  def valid_password?(%TimeManager.Accounts.User{password_hash: hashed_password}, password) do
    Bcrypt.check_pass(password, hashed_password)
  end
end
