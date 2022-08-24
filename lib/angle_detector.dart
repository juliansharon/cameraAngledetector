import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AngleDetector extends StatefulWidget {
  const AngleDetector({Key? key}) : super(key: key);

  @override
  State<AngleDetector> createState() => _AngleDetectorState();
}

class _AngleDetectorState extends State<AngleDetector> {
  String angle = "";
  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      debugPrint(event.toString());
      setState(() {
        angle = event.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('angle')),
    );
  }
}
