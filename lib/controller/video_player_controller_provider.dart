import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerProvider extends GetxController {
  late VideoPlayerController videoController;

  void pauseVideo() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    }
  }
}
