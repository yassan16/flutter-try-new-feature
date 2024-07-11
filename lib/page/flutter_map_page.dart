import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class FlutterMapPage extends StatefulWidget {
  const FlutterMapPage({super.key});

  @override
  State<FlutterMapPage> createState() => _FlutterMapPageState();
}

class _FlutterMapPageState extends State<FlutterMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Map',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: FlutterMap(
          options: const MapOptions(
            // 名古屋駅の緯度経度
            initialCenter: LatLng(35.170915, 136.881537),
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
          ],
      ),
    );
  }
}
