defmodule PhoenixVideoStreamWeb.WatchController do
  use PhoenixVideoStreamWeb, :controller

  import PhoenixVideoStream.Util
  alias PhoenixVideoStream.Media

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    video = Media.get_video!(id)
    send_video(conn, headers, video)
  end
end
