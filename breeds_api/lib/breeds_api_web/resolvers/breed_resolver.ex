defmodule BreedsApiWeb.BreedResolver do
  alias BreedApi.Dogs

  def all_breeds(_root, _args, _info) do
    {:ok, Dogs.list_breeds()}
  end

  def create_breed(_root, args, _info) do
    IO.inspect(args, label: "args")
    Dogs.create_breed(args)
  end
end
