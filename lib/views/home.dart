import 'package:emergency_relief/views/googleMaps.dart';
import 'package:emergency_relief/views/video.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MapsView()));
              },
              child: Text('Google maps'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VideoScreen()));
              },
              child: Text('Video'),
            ),
          ],
        ),
      ),
    );
  }
}
