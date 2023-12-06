defmodule BreedsApiWeb.Schema do
  use Absinthe.Schema

  alias BreedsApiWeb.BreedResolver

  import_types(Absinthe.Plug.Types)

  object :breed do
    field(:name, non_null(:string))
    field(:image_url, non_null(:string))
  end

  query do
    @desc "Get all breeds"
    field :all_breeds, non_null(list_of(non_null(:breed))) do
      resolve(&BreedResolver.all_breeds/3)
    end
  end

  mutation do
    @desc "Create new breed"
    field :create_breed, :string do
      arg(:image, non_null(:upload))
      arg(:breed_name, non_null(:string))

      resolve(&BreedResolver.create_breed/3)
      # resolve(fn args, _ ->
      #   with %Plug.Upload{path: path} <- IO.inspect(args.image),
      #        {:ok, content} <- File.read(path),
      #        filename <-
      #          String.split(args.breed_name) |> Enum.map(&String.downcase/1) |> Enum.join("_"),
      #        write_path <- Application.app_dir(:community, "priv/static/#{filename}.jpg"),
      #        :ok <- File.write(write_path, content) do
      #     {:ok, "success"}
      #   else
      #     {:error, error} -> {:error, error}
      #   end
      # end)
    end
  end
end
