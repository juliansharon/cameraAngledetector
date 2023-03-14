import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';

class AngleDetector extends StatefulWidget {
  const AngleDetector({Key? key}) : super(key: key);

  @override
  State<AngleDetector> createState() => _AngleDetectorState();
}

class _AngleDetectorState extends State<AngleDetector> {
  String acc = "";
  List accread = [];
  bool stop = false;

  @override
  void initState() {
    super.initState();
    motionSensors.orientation.listen((event) {
      debugPrint(event.pitch.toString());
    });
    // gyroscopeEvents.listen((GyroscopeEvent event) {
    //   // debugPrint(event.toString());
    // });
    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   final norm_g =
    //       sqrt(event.x * event.x + event.y * event.y + event.x * event.z);
    //   final x = event.x / norm_g;
    //   final y = event.y / norm_g;
    //   final z = event.z / norm_g;
    //   final inclination = acos(z) * 180 / pi;
    //   if (inclination < 25 || inclination > 155) {
    //     // device is flat
    //   } else {
    //     setState(() {
    //       var angle =
    //           atan(event.y / sqrt((event.x * event.x) + (event.z * event.z)));
    //       angle = angle - 0.05;
    //       acc = angle.toStringAsFixed(2);
    //     });
    //   }

    //   setState(() {
    //     if (!stop) {
    //       accread.add(event);
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: const Text("Stop"),
        onPressed: () {
          setState(() {
            stop = true;
          });
        },
      ),
      // body: ListView.builder(
      //     itemCount: accread.length,
      //     itemBuilder: (context, index) => Center(
      //           child: Row(
      //             children: [
      //               Text("x : ${accread[index].x.toStringAsFixed(3)}"),
      //               Text("y : ${accread[index].y.toStringAsFixed(3)}"),
      //               Text("z : ${accread[index].z.toStringAsFixed(3)}"),
      //             ],
      //           ),
      //         )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(acc)),
        ],
      ),
    );
  }
}
