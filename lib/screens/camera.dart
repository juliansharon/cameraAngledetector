import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_angle_detector/cubits/cubit/hologram_capture_cubit.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class HologramCamera extends StatefulWidget {
  const HologramCamera({Key? key}) : super(key: key);

  @override
  State<HologramCamera> createState() => _HologramCameraState();
}

class _HologramCameraState extends State<HologramCamera> {
  final HologramCaptureCubit _cubit = HologramCaptureCubit();
  @override
  void initState() {
    super.initState();
    _cubit.initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<HologramCaptureCubit, HologramCaptureState>(
          builder: ((context, state) {
            if (state is HologramCaptureInitial) {
              return _showLoader();
            }
            if (state is HologramCamptureActive) {
              return _showCameraPreview(state);
            }
            if (state is HologramPreview) {
              return _showPreview(state);
            }
            return Container();
          }),
        ),
      ),
    );
  }

  Widget _showLoader() {
    return const Center(
      child: Text("your camera is loading.."),
    );
  }

  Widget _showCameraPreview(HologramCamptureActive state) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(child: CameraPreview(_cubit.controller)),
            Text(
              state.instruction.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            _showOverLay()
          ],
        ),
        ElevatedButton(
            onPressed: () => {
                  _cubit.captureImage(state),
                },
            child: const Text("Record"))
      ],
    );
  }

  _showOverLay() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.white,
      )),
    );
  }

  _showPreview(HologramPreview state) {
    final manager = FlickManager(
        videoPlayerController:
            VideoPlayerController.file(File(state.video?.path ?? "")));
    return Column(
      children: [
        Expanded(
          // child: ListView.builder(
          //   itemCount: state.images.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Image.file(File(state.images[index].path));
          //   },
          // ),
          child: FlickVideoPlayer(flickManager: manager),
        ),
        ElevatedButton(
            onPressed: () => _cubit.initializeCamera(),
            child: const Text("Capture"))
      ],
    );
  }
}
