defmodule PhoenixVideoStream.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixVideoStream.Media` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        content_type: "some content_type",
        filename: "some filename",
        path: "some path",
        title: "some title"
      })
      |> PhoenixVideoStream.Media.create_video()

    video
  end
end
