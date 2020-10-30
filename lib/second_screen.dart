import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music/bookmarks.dart';
import 'musicProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  addToBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = [
      widget.trackDetails['track_name'],
      widget.trackDetails['artist_name'],
      widget.trackDetails['album_name'],
      widget.trackDetails['explicit'] == 1 ? 'True' : 'False',
      widget.trackDetails['rating'].toString(),
      lyrics
    ];
    await prefs.setStringList(widget.trackId.toString(), data);
    print('------------${prefs.getKeys().length}');
  }

  getBookmarks(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.remove('201279280');
    List<String> data = prefs.getStringList(key);

    return data;
  }

  void getAllKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    print(keys);
  }

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

  void bookMarkTrack() async {
    String data;
    print(widget.trackId);
    await addToBookmarks();
    List<String> value = await getBookmarks(widget.trackId.toString());
    print('${widget.trackId.toString()}=======$value');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookMarks();
    }));
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
            floatingActionButton: Visibility(
              visible: widget.trackDetails.keys.length != 6,
              child: FloatingActionButton(
                tooltip: 'Bookmark this track ',
                child: Icon(Icons.bookmark),
                onPressed: () {
                  bookMarkTrack();
                  Fluttertoast.showToast(
                      msg: "Track Bookmarked",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),
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
