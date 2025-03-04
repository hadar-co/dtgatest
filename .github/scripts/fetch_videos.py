import json
import requests
import isodate
PLAYLIST_ID = [YOUR_PLAYLIST_ID]
PLAYLIST_ITEMS_URL = f"https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&key=[YOUR_API_KEY]&playlistId={PLAYLIST_ID}&maxResults=30"
VIDEO_URL = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&part=contentDetails&part=snippet&key=[YOUR_API_KEY]&id={video_id}"

# Convert ISO to date time.
def iso_to_seconds(iso_duration):
    duration = isodate.parse_duration(iso_duration)  # Convert to timedelta
    return int(duration.total_seconds())  # Get total seconds

# Parse the raw response into blueprint properties
def construct_video(get_snippet, video_content_details, get_video_stats_response, video_id):
    properties = dict()
    properties["video_link"] = f"https://youtube.com/watch?v={video_id}"
    properties["views"] = get_video_stats_response["viewCount"]
    properties["likes"] = get_video_stats_response["likeCount"]
    properties["comments"] = get_video_stats_response["commentCount"]
    properties["duration"] = iso_to_seconds(video_content_details["duration"])
    properties["published"] = get_snippet["publishedAt"]
    return properties

# Due to the use of BULK_UPSERT, we enrich every object with additional fields
def enrich_with_blueprint_properties(properties, snippet, video, video_id):
    video["identifier"] = video_id
    video["title"] = snippet["title"]
    video["blueprint"] = "video"
    video["properties"] = properties

def fetch_videos():
    # Get videos data using playlist ID.
    playlist_items = requests.get(PLAYLIST_ITEMS_URL).json()["items"]

    # Collect videos data.
    videos = []
    for item in playlist_items:
        video = dict()
        video_id = item["snippet"]["resourceId"]["videoId"]

        # Get video data
        video_response = requests.get(VIDEO_URL.format(video_id=video_id)).json()
        # In case of missing data, skip video parsing
        if not video_response.get("items"):
            continue

        video_statistics = video_response["items"][0]["statistics"]
        video_snippet = video_response["items"][0]["snippet"]
        video_content_details = video_response["items"][0]["contentDetails"]

        properties = construct_video(video_snippet, video_content_details, video_statistics, video_id)
        enrich_with_blueprint_properties(properties, video_snippet, video, video_id)

        videos.append(video)

    return videos

if __name__ == "__main__":
    print(json.dumps(fetch_videos()))
