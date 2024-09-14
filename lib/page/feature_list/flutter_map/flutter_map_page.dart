import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_try_new_feature/model/get_current_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


class FlutterMapPage extends StatefulWidget {
  const FlutterMapPage({super.key});

  @override
  State<FlutterMapPage> createState() => _FlutterMapPageState();
}

class _FlutterMapPageState extends State<FlutterMapPage> {

  @override
  void initState() {
    super.initState();
  }


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
          // 初期ズーム設定
          initialZoom: 10.0,
          // 拡大設定
          // maxZoom: 12.0,
          // 縮小設定
          // minZoom: 1.0,
          // 東京駅の緯度経度
          initialCenter: LatLng(35.6809591, 139.7673068),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                  width: 30.0,
                  height: 30.0,
                  // ピンの位置を設定
                  point: LatLng(35.6809591, 139.7673068),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                     // ここでピンのサイズを調整
                    size: 50,
                  ),
                  // マップを回転させた時にピンも回転するのが rotate: false,
                  // マップを回転させた時にピンは常に同じ向きなのが rotate: true,
                  rotate: true,
              ),
            ],
          ),
        ],

      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ,
      //   child: Icon(Icons.location_on),
      //   ),

    );
  }
}
