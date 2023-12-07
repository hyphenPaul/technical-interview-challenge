defmodule BreedsWeb.Breeds do
  use BreedsWeb, :live_view
  alias BreedsWeb.UploadForm

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flow-root h-20 border-b mb-10">
      <h1 class="text-3xl font-bold uppercase float-left">Dog Breeds</h1>
      <.button type="button" class="float-right" phx-click={show_modal("new-breed-modal")}>
        Upload Breed
      </.button>
    </div>

    <.modal id="new-breed-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.live_file_input upload={@uploads.image} required />
        <.input field={@form["name"]} type="text" label="Name" required />

        <.button type="submit" phx-disable-with="Saving ...">Upload Breed</.button>
      </.simple_form>
    </.modal>

    <div id="breeds" class="flex flex-col gap-2">
      <div :for={breed <- @breeds} class="mx-auto flex flex-col gap-2 p-4 border rounded">
        <h2 class="uppercase font-bold"><%= breed["name"] %></h2>
        <image src={breed["image_url"]} />
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form_fields = %{"image" => "", "name" => ""}

    socket =
      socket
      |> assign(breeds: get_breeds())
      |> assign(form: to_form(form_fields))
      |> allow_upload(:image, accept: ~w(.jpg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", unsigned_params, socket) do
    # This take the stored file and passes it to the 
    # API. It's basically a rerun of the multipart request
    # this app just received.
    #
    # This is wild, and wouldn't happen using a front end
    # framework. Another interesting part of liveveiw's design
    result =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        HTTPoison.post(
          "localhost:4000/api",
          {:multipart,
           [
             {:file, path,
              {"form-data",
               [
                 {"name", "image_file"},
                 {"filename", "upload.jpeg"},
                 {"content_type", "image/jpeg"}
               ]}, []},
             {"query",
              "mutation {createBreed(image: \"image_file\", breed_name: \"#{unsigned_params["name"]}\")}"}
           ]}
        )
      end)

    case Jason.decode(result.body) do
      {:ok, %{"data" => %{"createBreed" => "success"}}} ->
        socket =
          socket
          |> assign(breeds: get_breeds())
          |> put_flash(:info, "You uploaded a new breed!")

        {:noreply, socket}

      _ ->
        {:noreply, put_flash(socket, :error, "Something went wrong")}
    end
  end

  @spec get_breeds :: list(map()) | {:error, String.t()}
  defp get_breeds do
    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.post("localhost:4000/api", "query {all_breeds {name image_url}}"),
         {:ok, %{"data" => %{"all_breeds" => breeds}}} <- Jason.decode(body) do
      breeds
    else
      _ -> {:error, "There was an error fetching the breeds"}
    end
  end
end
