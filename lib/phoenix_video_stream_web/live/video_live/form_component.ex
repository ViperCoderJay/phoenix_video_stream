defmodule PhoenixVideoStreamWeb.VideoLive.FormComponent do
  use PhoenixVideoStreamWeb, :live_component
  import PhoenixVideoStream.Util, only: [build_video_path: 1]

  alias PhoenixVideoStream.Media

  # @impl true
  # def mount(socket) do
  #   {:ok, allow_upload(socket, :video_file, accept: ~w(video/mp4 video/*), max_entries: 1)}
  # end

  @impl true
  def update(%{video: video} = assigns, socket) do
    changeset = Media.change_video(video)

    socket = socket
    |> assign(assigns)
    |> assign(:changeset, changeset)
    |> allow_upload(:video_file, accept: ~w(video/mp4 video/*), max_entries: 1)

    {:ok, socket}

  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl true
  def handle_event("validate", %{"video" => video_params} = params, socket) do
    IO.inspect(params)
    changeset =
      socket.assigns.video
      |> Media.change_video(video_params)
      |> Map.put(:action, :validate)

      IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"video" => video_params}, socket) do
    save_video(socket, socket.assigns.action, video_params)
  end

  def cancel_upload(%{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :video_file, ref)}
  end

  defp save_video(socket, :edit, video_params) do
    case Media.update_video(socket.assigns.video, video_params) do
      {:ok, _video} ->
        {:noreply,
         socket
         |> put_flash(:info, "Video updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_video(socket, :new, video_params) do
    IO.inspect(video_params)
    case Media.create_video(video_params) do
      {:ok, video} ->
        persist_file(video, video_params["video_file"])
        {:noreply,
         socket
         |> put_flash(:info, "Video created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp persist_file(video, %{path: temp_path}) do
    video_path = build_video_path(video)
    unless File.exists?(video_path) do
      video_path |> Path.dirname() |> File.mkdir_p()
      File.copy!(temp_path, video_path)
    end
  end

  def friendly_error(:too_large), do: "Video too large"
  def friendly_error(:too_many_files), do: "Too many files"
  def friendly_error(:not_accepted), do: "Unacceptable file type"
end
