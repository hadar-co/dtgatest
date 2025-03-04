import json
import requests
PLAYLIST_ID = "PLOipq2_FbKCM9hv-6AGcxx32i5vrydWFv"
PLAYLIST_ITEMS_URL = f"https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&key=[YOUR_API_KEY]&playlistId={PLAYLIST_ID}&maxResults=30"
PLAYLIST_NAME_URL = f"https://www.googleapis.com/youtube/v3/playlists?part=snippet&part=ContentDetails&id={PLAYLIST_ID}&key=[YOUR_API_KEY]"
VIDEO_URL = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&part=contentDetails&key=[YOUR_API_KEY]&id={video_id}"

def enrich_with_blueprint_properties(playlist, playlist_name, properties, videos_in_playlist):
    playlist["identifier"] = PLAYLIST_ID
    playlist["title"] = playlist_name
    playlist["properties"] = properties
    playlist["blueprint"] = "youtube_playlist"
    playlist["relations"] = {"videos": videos_in_playlist}

# Parse the raw response into blueprint properties
def construct_playlist(playlist_name, response):
    properties = dict()
    properties["playlist_name"] = playlist_name
    properties["video_count"] = response["items"][0]["contentDetails"]["itemCount"]
    return properties

def get_videos(playlist_items):
    # Retrieve all video IDs
    videos = []
    for item in playlist_items:
        snippet = item["snippet"]
        resource_id = snippet["resourceId"]
        video_id = resource_id["videoId"]

        # Get video
        resp = requests.get(VIDEO_URL.format(video_id=video_id)).json()
        if not resp.get("items"):
            # drop videos without items object
            continue
        videos.append(video_id)
    return videos

def fetch_playlist():
    playlist = dict()

    # Get Playlist data
    playlist_items = requests.get(PLAYLIST_ITEMS_URL).json()["items"]
    response = requests.get(PLAYLIST_NAME_URL).json()
    playlist_name = response["items"][0]["snippet"]["title"]

    # Get videos in playlist
    videos_in_playlist = get_videos(playlist_items)

    properties = construct_playlist(playlist_name, response)
    enrich_with_blueprint_properties(playlist, playlist_name, properties, videos_in_playlist)

    return playlist

if __name__ == "__main__":
    print(json.dumps(fetch_playlist()))
