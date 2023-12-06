defmodule BreedApi.Dogs do
  @moduledoc """
  A context style CRUD interface using the local filesystem
  instead of a database.
  """

  alias BreedsApi.Breed

  @spec list_breeds :: list(Breed.t())
  def list_breeds do
    Enum.map(list_files(), &Breed.new_from_file_name/1)
  end

  @spec create_breed(map()) :: {:ok, Breed.t()} | {:error, String.t()}
  def create_breed(%{image: image, breed_name: breed_name}) do
    with {:ok, file_name} <- Breed.build_file_name(breed_name),
         :ok <- validate_uniq?(file_name),
         :ok <- validate_jpeg?(image) do
      File.cp!(image.path, write_path(file_name))

      {:ok, "success"}
    else
      {:error, error} -> {:error, error}
    end
  end

  def create_breed(_), do: {:error, "Creating a breed requires an image and breed name"}

  @spec images_path :: String.t()
  defp images_path do
    Path.join([:code.priv_dir(:breeds_api), "static", "images"])
  end

  @spec validate_jpeg?(Plug.Upload.t()) :: :ok | {:error, String.t()}
  defp validate_jpeg?(%{content_type: "image/jpeg"}), do: :ok
  defp validate_jpeg?(_), do: {:error, "Image must be a jpeg"}

  @spec validate_uniq?(String.t()) :: :ok | {:error, String.t()}
  defp validate_uniq?(file_name) do
    if Enum.member?(list_files(), file_name), do: {:error, "File alread exists"}, else: :ok
  end

  defp list_files do
    case File.ls(images_path()) do
      {:ok, file_names} -> file_names
      _ -> raise "Could not read file system"
    end
  end

  defp write_path(filename) do
    Application.app_dir(:breeds_api, "priv/static/images/#{filename}")
  end
end
