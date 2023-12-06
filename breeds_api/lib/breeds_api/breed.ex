defmodule BreedsApi.Breed do
  defstruct [:name, :image_url]

  @base_url "http://localhost:4000/images/"

  @type t :: %__MODULE__{
          name: String.t(),
          image_url: String.t()
        }

  @spec new_from_file_name(String.t()) :: t()
  def new_from_file_name(file_name) do
    %__MODULE__{
      name: build_name(file_name),
      image_url: build_url(file_name)
    }
  end

  @spec build_file_name(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def build_file_name(breed_name) do
    if Regex.match?(~r/^[a-z ]*$/, breed_name) do
      base = breed_name |> String.replace(" ", "_")
      {:ok, base <> ".jpg"}
    else
      {:error, "Breed name must contain only letters and spaces"}
    end
  end

  @spec build_name(String.t()) :: String.t()
  defp build_name(file_name) do
    file_name
    |> String.split(".")
    |> hd()
    |> String.replace("_", " ")
  end

  @spec build_url(String.t()) :: String.t()
  defp build_url(file_name) do
    @base_url <> file_name
  end
end
