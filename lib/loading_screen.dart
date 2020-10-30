import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:music/musicProvider.dart';
import 'dart:io';
import 'first_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool internetAvailable = true;

  void getMusic() async {
    MusicModel m = new MusicModel();
    var trackDetails = await m.getTrackIds();
    if (trackDetails != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FirstScreen(
          trackDetails: trackDetails,
        );
      }));
    } else {
      setState(() {
        //internetAvailable = false;
      });
    }
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          internetAvailable = true;
        });
        getMusic();
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        internetAvailable = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMusic();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //checkConnection();
    return Scaffold(
      body: Container(
        child: Center(
          child: internetAvailable
              ? SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 100.0,
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
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
