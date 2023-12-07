defmodule BreedsWeb.UploadForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:image_url, :string)
    field(:name, :string)
  end

  def changeset(%__MODULE__{} = form, attrs \\ %{}) do
    form
    |> cast(attrs, [:image_url, :name])
    |> validate_required([:image_url, :name])
  end
end
