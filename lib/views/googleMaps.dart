import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_relief/services/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsView extends StatefulWidget {
  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  Position position;
  GoogleMapController mapController;
  BitmapDescriptor _markerIcon;
  List<Marker> allMarkers = List<Marker>();
  // final  BitmapDescriptor customIcon;

  void getCurrentLocation() async {
    position = await GeoLocatorService.getLocation();
    setState(() {});
    return;
  }

  @override
  void initState() {
    getCurrentLocation();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 1000)),
            'assets/images/warning.png')
        .then((value) {
      setState(() {
        _markerIcon = value;
      });
    });
    super.initState();
  }

  void addMarkers(QuerySnapshot snapshot) {
    if (snapshot == null) return;

    for (DocumentSnapshot doc in snapshot.documents) {
      allMarkers.add(
        Marker(
          icon: _markerIcon != null ? _markerIcon : Icons.card_travel,
          markerId: MarkerId(doc.documentID),
          draggable: false,
          infoWindow: InfoWindow(title: ''),
          position: LatLng(
            double.parse(doc['lat']),
            double.parse(doc['long']),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final geoService = GeoLocatorService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps',
            style: GoogleFonts.lobster(color: Colors.black, fontSize: 25.0)),
        centerTitle: true,
      ),
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: Firestore.instance.collection('coordinates').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // To add the markers on to the google maps
                addMarkers(snapshot.data);

                return Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 16.0,
                        ),
                        markers: Set.from(allMarkers),
                        zoomGesturesEnabled: true,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
