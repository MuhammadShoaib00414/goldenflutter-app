import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/videos_model.dart';
import 'package:goldexia_fx/repositories/videos_repo.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';

class VideosProvider extends ChangeNotifier {
  final VideosRepo _repo = VideosRepo();

  ApiResponse<List<VideosModel>?> videos = ApiResponse.loading();

  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;

  bool _isReady = false;
  String? currentUrl;
  bool _isFullScreen = false;

  VideoPlayerController? get controller => _controller;
  ChewieController? get chewieController => _chewieController;
  YoutubePlayerController? get youtubeController => _youtubeController;
  bool get isReady => _isReady;
  bool get isFullScreen => _isFullScreen;

  VideosModel? selectedVideo;
  VideoFile? selectedFile;
  int selectedFileIndex = -1;

  void setFullScreen(bool value) {
    if (_isFullScreen == value) return;
    _isFullScreen = value;
    notifyListeners();
  }

  Future<void> getVideos() async {
    final res = await _repo.getVideos();
    _setVideos(res);
  }

  void toggleFolder(VideosModel folder, int index) {
    if (selectedVideo?.id == folder.id) {
      if (selectedFile != null && selectedVideo!.id == folder.id) {
        selectedFile = null;
        selectedFileIndex = -1;
      }
      selectedVideo = null;
    } else {
      selectedVideo = folder;
    }
    notifyListeners();
  }

  void _setVideos(ApiResponse<List<VideosModel>?> res) {
    videos = res;
    if (res.data != null && res.data!.isNotEmpty) {
      selectedVideo = null;
      selectedFile = null;
      selectedFileIndex = -1;
      _isReady = false;
    }
    notifyListeners();
  }

  void selectVideoFile(VideoFile file, int index) {
    selectedFile = file;
    selectedFileIndex = index;
    notifyListeners();
  }

  Future<void> loadVideo(String url, {String? source}) async {
    if (currentUrl == url && _isReady) return;

    currentUrl = url;
    _isReady = false;
    notifyListeners();

    await _pauseAll();

    final src = (source ?? "").toLowerCase();

    // Handle YouTube videos
    if (src == "youtube") {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId == null) {
        debugPrint("Invalid YouTube URL: $url");
        _isReady = false;
        notifyListeners();
        return;
      }

      try {
        _youtubeController?.pause();
        _youtubeController?.dispose();
        _youtubeController = null;
        await Future.delayed(const Duration(milliseconds: 250));
      } catch (_) {}

      final controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: false,
          disableDragSeek: false,
          loop: false,
          forceHD: false,
          useHybridComposition: true,
        ),
      );

      _youtubeController = controller;
      await Future.delayed(const Duration(milliseconds: 400));
      _isReady = true;
      notifyListeners();
      return;
    }

    // Handle MP4 / direct videos
    try {
      await _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller!.initialize();

      _chewieController?.dispose();
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: true,
        allowPlaybackSpeedChanging: true,
        deviceOrientationsOnEnterFullScreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],
        systemOverlaysAfterFullScreen: SystemUiOverlay.values,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.primary.withValues(alpha: 0.3),
          backgroundColor: Colors.white24,
        ),
      );

      _isReady = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load video: $e");
      _isReady = false;
      notifyListeners();
    }
  }

  Future<void> _pauseAll() async {
    // Pause MP4 video
    try {
      if (_controller?.value.isPlaying ?? false) {
        await _controller!.pause();
      }
    } catch (_) {}

    // Pause Chewie wrapper
    try {
      await _chewieController?.pause();
    } catch (_) {}

    // Pause YouTube video safely
    try {
      if (_youtubeController != null) {
        final yt = _youtubeController!;
        // Wait until player is initialized before pausing
        if (yt.value.isReady && yt.value.isPlaying) {
          yt.pause();
        } else {
          // Retry briefly if not ready yet
          await Future.delayed(const Duration(milliseconds: 200));
          if (yt.value.isPlaying) yt.pause();
        }
      }
    } catch (e) {
      debugPrint("pauseAll (YouTube) error: $e");
    }
  }


  Future<void> disposeControllers() async {
    try {
      await _controller?.dispose();
    } catch (_) {}
    try {
      _chewieController?.dispose();
    } catch (_) {}
    try {
      _youtubeController?.dispose();
    } catch (_) {}

    _controller = null;
    _chewieController = null;
    _youtubeController = null;
    _isReady = false;
    currentUrl = null;
    notifyListeners();
  }
}











