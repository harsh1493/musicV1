import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/second_screen.dart';

class FirstScreen extends StatefulWidget {
  final trackDetails;
  FirstScreen({@required this.trackDetails});
  static const String id = 'first_screen';
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<StatefulWidget> trackWidgets = [];
  List<Map> trackMaps = [];
  List<String> trackIds = [];
  bool internetAvailable = true;
  void populateTracks() {
    for (var trackDetail in widget.trackDetails) {
      trackWidgets.add(Track(trackMap: trackDetail));
    }
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
    //print(widget.musicData['body']);
    // TODO: implement initState
    populateTracks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkConnection();
    return internetAvailable
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Trending',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              children: trackWidgets,
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

class Track extends StatefulWidget {
  final trackMap;
  Track({@required this.trackMap});
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.trackMap['track_id']);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SecondScreen(
            trackId: widget.trackMap['track_id'],
            trackDetails: widget.trackMap,
          );
        }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(Icons.library_music),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trackMap['track_name'],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.trackMap['album_name'],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            trailing: SizedBox(
              width: 60,
              child: Text(
                widget.trackMap['artist_name'],
                style: TextStyle(fontSize: 15),
                maxLines: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
