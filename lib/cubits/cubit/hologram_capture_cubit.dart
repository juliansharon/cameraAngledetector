import 'dart:io';

import 'package:camera/camera.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:vector_math/vector_math.dart';

part 'hologram_capture_state.dart';

class HologramCaptureCubit extends Cubit<HologramCaptureState> {
  HologramCaptureCubit() : super(HologramCaptureInitial());
  late CameraController controller;
  late DateTime startTime;
  int count = 0;
  void initializeCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    count = 0;
    controller.initialize().then(
      (_) {
        emit(
          HologramCamptureActive(),
        );
        getPich();
      },
    );
  }

  void getPich() {
    try {
      motionSensors.orientation.listen(
        (event) async {
          if (state is HologramCamptureActive) {
            if ((state as HologramCamptureActive).recordStatus ==
                RecordStatus.idle) {
              emit((state as HologramCamptureActive)
                  .copyWith(instruction: "Click Record Button"));
            } else {
              emit(
                (state as HologramCamptureActive).copyWith(
                  pitch: degrees(event.pitch),
                ),
              );
              if (degrees(event.pitch) < 40) {
                emit(
                  (state as HologramCamptureActive).copyWith(
                    instruction: "Slowly tilt your phone backwards",
                  ),
                );
              } else if (degrees(event.pitch) > 40 &&
                  degrees(event.pitch) < 60) {
                emit(
                  (state as HologramCamptureActive)
                      .copyWith(instruction: "Hold Steady!!"),
                );

                if (count <= 10 &&
                    (state as HologramCamptureActive).recordStatus ==
                        RecordStatus.recording) {
                  count++;
                  final currentFrame = DateTime.now().difference(startTime);

                  debugPrint(currentFrame.toString());
                } else {
                  controller.setFlashMode(FlashMode.off);
                  final video = await controller.stopVideoRecording();
                  (state as HologramCamptureActive).copyWith(
                    recordStatus: RecordStatus.idle,
                  );
                  showPreview(video);
                  saveFile(video);
                }
              } else {
                emit(
                  (state as HologramCamptureActive).copyWith(
                    instruction: "Slowly tilt your phone forwards",
                  ),
                );
              }
            }
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void captureImage(HologramCamptureActive state) async {
    try {
      controller.setFlashMode(FlashMode.torch);
      emit(
        state.copyWith(
          recordStatus: RecordStatus.recording,
        ),
      );
      await controller.startVideoRecording();
      startTime = DateTime.now();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showPreview(XFile video) {
    if (state is HologramCamptureActive) {
      emit(HologramPreview(video: video));
    }
  }

  void saveFile(XFile video) async {
    final appDocumentsDirectory = DownloadsPathProvider.downloadsDirectory;
    final byteData = await File(video.path).readAsBytes();
    final File file = File("/storage/emulated/0/Download/holgram.mp4");
    await file.writeAsBytes(byteData).onError((error, stackTrace) {
      debugPrint("file error ");
      return File("");
    }).whenComplete(
      () => debugPrint("file written success fully"),
    );
    debugPrint("local path====> $appDocumentsDirectory");
  }
}
