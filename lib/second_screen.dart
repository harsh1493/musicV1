import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'musicProvider.dart';

class SecondScreen extends StatefulWidget {
  final trackId;
  final Map trackDetails;
  SecondScreen({@required this.trackId, @required this.trackDetails});
  static const String id = 'second_screen';
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var trackMap = new Map();
  String lyrics;
  bool internetAvailable = true;

  void getDetails() async {
    MusicModel m = new MusicModel();
    var trackDetails = await m.getTrackDetails(widget.trackId.toString());
    trackMap = trackDetails['message']['body']['track'];
    print(trackMap);
  }

  void getLyrics() async {
    MusicModel m = MusicModel();
    var lyric = await m.getLyrics(widget.trackId.toString());
    setState(() {
      lyrics = lyric;
    });
    print('-----------$lyric');
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        setState(() {
          internetAvailable = true;
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
      setState(() {
        internetAvailable = false;
      });
    }
  }

  @override
  void initState() {
    trackMap = widget.trackDetails;
    // TODO: implement initState
    getLyrics();
    print(widget.trackId);
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkConnection();
    return internetAvailable
        ? Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //modify arrow color from here..
              ),
              title: Text(
                'Track Details',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            body: TrackInfo(
              lyrics: lyrics,
              trackInfo: trackMap,
            ),
          )
        : Container(
            padding: EdgeInsets.only(top: 140),
            color: Color.fromRGBO(251, 251, 251, 1),
            child: Column(
              children: [
                Image(
                  image: AssetImage(
                    'images/no_connection.gif',
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Oops! \n No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 30),
                ),
              ],
            ));
  }
}

class TrackInfo extends StatelessWidget {
  final Map trackInfo;
  final lyrics;
  TrackInfo({@required this.trackInfo, @required this.lyrics});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: ListView(
        children: [
          InfoTile(
            title: 'Title',
            content: trackInfo['track_name'].toString(),
          ),
          InfoTile(title: 'Artist', content: trackInfo['artist_name']),
          InfoTile(title: 'Album Name', content: trackInfo['album_name']),
          InfoTile(
              title: 'Explicit',
              content: trackInfo['explicit'] == 1 ? 'True' : 'False'),
          InfoTile(
              title: 'Rating', content: trackInfo['track_rating'].toString()),
          lyrics != '-' && lyrics != null
              ? InfoTile(title: 'Lyrics', content: lyrics)
              : SizedBox(
                  height: 350,
                  child: Container(
                    padding: EdgeInsets.all(100),
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final title;
  final content;
  InfoTile({@required this.title, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
