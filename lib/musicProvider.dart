import 'networking.dart';

class MusicModel {
  Future<dynamic> getTrackIds() async {
    List<Map> trackDetails = [];
    NetworkHelper nh = new NetworkHelper(
        'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7');
    var musicData = await nh.getData();
    print(musicData);
    if (musicData != null) {
      for (var track in musicData['message']['body']['track_list']) {
        trackDetails.add(track['track']);
      }
      return trackDetails;
    }
    return null;
  }

  Future<dynamic> getTrackDetails(String trackId) async {
    NetworkHelper nh = new NetworkHelper(
        'https://api.musixmatch.com/ws/1.1/track.get?track_id=' +
            trackId +
            '&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7');
    var trackDetails = await nh.getData();
    print(trackDetails == null);
    return trackDetails;
  }

  Future<dynamic> getLyrics(String trackId) async {
    NetworkHelper nh = new NetworkHelper(
        'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=' +
            trackId +
            '&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7');
    var lyrics = await nh.getData();
    print(lyrics == null);

    lyrics = lyrics['message']['body']['lyrics']['lyrics_body'];
    print(lyrics);
    return lyrics;
  }
}
