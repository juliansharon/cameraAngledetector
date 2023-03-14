part of 'hologram_capture_cubit.dart';

enum RecordStatus { idle, recording }

@immutable
abstract class HologramCaptureState {}

class HologramCaptureInitial extends HologramCaptureState {}

class HologramCamptureActive extends HologramCaptureState {
  final double? pitch;
  final List<XFile> imageList;
  final String? instruction;
  final List? timeFrame;
  final RecordStatus recordStatus;
  HologramCamptureActive({
    this.recordStatus = RecordStatus.idle,
    this.pitch = 0,
    this.imageList = const [],
    this.instruction = "",
    this.timeFrame = const [],
  });

  HologramCamptureActive copyWith({
    double? pitch,
    List<XFile>? imageList,
    String? instruction,
    List? timeFrame,
    RecordStatus? recordStatus,
  }) {
    return HologramCamptureActive(
      pitch: pitch ?? this.pitch,
      imageList: imageList ?? this.imageList,
      instruction: instruction ?? this.instruction,
      timeFrame: timeFrame ?? this.timeFrame,
      recordStatus: recordStatus ?? this.recordStatus,
    );
  }
}

class HologramPreview extends HologramCaptureState {
  final List<XFile>? images;
  final XFile? video;
  HologramPreview({this.images, this.video});
}
