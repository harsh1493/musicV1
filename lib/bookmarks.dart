import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

int c;

class BookMarks extends StatefulWidget {
  static const String id = 'bookmarks';
  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  bool internetAvailable = true;
  List<StatefulWidget> trackWidgets = [];
  void populateBookmarks() async {
    //trackWidgets = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> data = [];
    var keys = prefs.getKeys();
    //print('-++++++++++${keys.length}');
    c = keys.length;

    setState(() {
      for (var key in keys) {
        // print(key);
        data = prefs.get(key).toList();
        //print(data[0]);
        trackWidgets.add(Track(
          trackDetails: prefs.get(key).toList(),
          trackId: key.toString(),
        ));
      }
    });
  }

  void clearBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      trackWidgets.clear();
    });
    //print('****${prefs.getKeys().length}');
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
    // trackWidgets.clear();
    populateBookmarks();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkConnection();
    return internetAvailable
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Bookmarks',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              itemCount: trackWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return trackWidgets[index];
              },
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Delete all bookmarks',
              onPressed: () {
                setState(() {
                  clearBookmarks();
                });
              },
              child: Icon(Icons.clear),
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
  final List<dynamic> trackDetails;
  final String trackId;
  Track({@required this.trackDetails, @required this.trackId});
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  var trackDetails = new Map();
  void setDetails() {
    setState(() {
      trackDetails['track_name'] = widget.trackDetails[0].toString();
      trackDetails['artist_name'] = widget.trackDetails[1].toString();
      trackDetails['album_name'] = widget.trackDetails[2].toString();
      trackDetails['explicit'] = widget.trackDetails[3].toString();
      trackDetails['track_rating'] = widget.trackDetails[4].toString();
      trackDetails['lyrics'] = widget.trackDetails[5].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.trackId);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SecondScreen(
            trackId: widget.trackId.toString(),
            trackDetails: trackDetails,
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
                  widget.trackDetails[0],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.trackDetails[2],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            trailing: SizedBox(
              width: 60,
              child: Text(
                widget.trackDetails[1],
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
