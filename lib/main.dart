import 'dart:async';
import 'dart:typed_data';

import 'package:emergency_relief/views/home.dart';
import 'package:emergency_relief/views/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: Home());
  }
}
