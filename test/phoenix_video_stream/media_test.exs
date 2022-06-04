defmodule PhoenixVideoStream.MediaTest do
  use PhoenixVideoStream.DataCase

  alias PhoenixVideoStream.Media

  describe "videos" do
    alias PhoenixVideoStream.Media.Video

    import PhoenixVideoStream.MediaFixtures

    @invalid_attrs %{content_type: nil, filename: nil, path: nil, title: nil}

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Media.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Media.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      valid_attrs = %{content_type: "some content_type", filename: "some filename", path: "some path", title: "some title"}

      assert {:ok, %Video{} = video} = Media.create_video(valid_attrs)
      assert video.content_type == "some content_type"
      assert video.filename == "some filename"
      assert video.path == "some path"
      assert video.title == "some title"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      update_attrs = %{content_type: "some updated content_type", filename: "some updated filename", path: "some updated path", title: "some updated title"}

      assert {:ok, %Video{} = video} = Media.update_video(video, update_attrs)
      assert video.content_type == "some updated content_type"
      assert video.filename == "some updated filename"
      assert video.path == "some updated path"
      assert video.title == "some updated title"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_video(video, @invalid_attrs)
      assert video == Media.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Media.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Media.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Media.change_video(video)
    end
  end
end
