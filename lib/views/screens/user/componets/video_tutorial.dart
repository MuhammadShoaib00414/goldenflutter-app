import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:goldexia_fx/models/videos_model.dart';
import 'package:goldexia_fx/providers/videos_provider.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTutorialScreen extends StatefulWidget {
  const VideoTutorialScreen({super.key});

  @override
  State<VideoTutorialScreen> createState() => _VideoTutorialScreenState();
}

class _VideoTutorialScreenState extends State<VideoTutorialScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VideosProvider>().getVideos());
  }

  @override
  void dispose() {
    context.read<VideosProvider>().setFullScreen(false);
    context.read<VideosProvider>().disposeControllers();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prim = AppColors.primary;

    return Consumer<VideosProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBlackColor,
          appBar: provider.isFullScreen
    ? null
    : PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: AppBar(
            key: ValueKey(provider.isFullScreen),
            toolbarHeight: 40,
            elevation: 0,
            backgroundColor: AppColors.darkBlackColor,
            title: Text(
              'Video Tutorials',
              style: AppTextStyles.s18M.copyWith(color: prim),
            ),
          ),
        ),
      ),
          body: _buildBody(context, provider, prim),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, VideosProvider provider, Color prim) {
    final res = provider.videos;

    if (res.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (res.isError) {
      return Center(
        child: Text(
          res.message ?? 'Error',
          style: AppTextStyles.s14M.copyWith(color: Colors.white),
        ),
      );
    }

    final videoList = res.data ?? [];
    final selectedFile = provider.selectedFile;
    final chewie = provider.chewieController;

    Widget buildVideoBox({required bool showClose, required bool fullScreen}) {
      final screen = MediaQuery.of(context).size;
      final targetHeight = screen.width * 9 / 16;
      final maxHeight = screen.height * 0.9;
      final fullHeight = math.min(targetHeight, maxHeight);

      return Container(
        margin: fullScreen ? EdgeInsets.zero : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: fullScreen
              ? BorderRadius.zero
              : BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [prim.withAlpha(30), prim.withAlpha(10)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: prim.withAlpha(100)),
          boxShadow: fullScreen
              ? []
              : [
                  BoxShadow(
                    color: prim.withAlpha(60),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: fullScreen ? fullHeight : null,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: fullScreen
                  ? BorderRadius.zero
                  : BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildPlayer(
                      provider: provider,
                      selectedFile: selectedFile,
                      chewie: chewie,
                      prim: prim,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildFoldersList({required bool shrinkWrap}) {
      return ListView.separated(
        controller: shrinkWrap ? null : scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        itemBuilder: (context, index) {
          final folder = videoList[index];
          final files = folder.videoFiles ?? [];
          final isOpen = provider.selectedVideo?.id == folder.id;

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashColor: prim.withAlpha(50),
              highlightColor: prim.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                provider.toggleFolder(folder, index);
                if (!shrinkWrap) {
                  scrollController.animateTo(
                    index * 80.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                color: isOpen ? prim.withAlpha(15) : Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isOpen ? Icons.folder_open : Icons.folder,
                          color: prim,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            folder.videoTitle ?? 'Untitled',
                            style: AppTextStyles.s16M.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${files.length} videos',
                          style: AppTextStyles.s13M.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.expand_more,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      folder.description ?? '',
                      style: AppTextStyles.s13M.copyWith(color: Colors.white60),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      child: isOpen
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: files.asMap().entries.map((e) {
                                  final f = e.value;
                                  final idx = e.key;
                                  final playing =
                                      provider.selectedVideo?.id == folder.id &&
                                      provider.selectedFileIndex == idx;

                                  return GestureDetector(
                                    onTap: () {
                                      provider.selectVideoFile(f, idx);
                                      provider.loadVideo(
                                        f.url!,
                                        source: f.source,
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: playing
                                            ? prim.withAlpha(30)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: playing
                                              ? prim
                                              : prim.withAlpha(40),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.play_circle_fill,
                                            color: prim,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              f.title ?? 'Video ',
                                              style: AppTextStyles.s14M
                                                  .copyWith(
                                                    color: playing
                                                        ? prim
                                                        : Colors.white,
                                                  ),
                                            ),
                                          ),
                                          if (playing)
                                            Icon(Icons.equalizer, color: prim),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: videoList.length,
      );
    }

    if (provider.isFullScreen) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildVideoBox(showClose: true, fullScreen: true),
              if (selectedFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          provider.selectedVideo?.videoTitle ?? '',
                          style: AppTextStyles.s16M.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        selectedFile.title ?? '',
                        style: AppTextStyles.s13M.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              buildFoldersList(shrinkWrap: true),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // ------------------ Video Player Section ------------------
        buildVideoBox(showClose: false, fullScreen: false),
        // ------------------ Video Folders List ------------------
        Expanded(child: buildFoldersList(shrinkWrap: false)),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildPlayer({
    required VideosProvider provider,
    required VideoFile? selectedFile,
    required ChewieController? chewie,
    required Color prim,
  }) {
    if (selectedFile == null) return _buildPlaceholder(prim);

    if (!provider.isReady) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (selectedFile.source == 'youtube') {
      final yt = provider.youtubeController!;
      return YoutubePlayerBuilder(
        onEnterFullScreen: () async {
          provider.setFullScreen(true);
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky,
          );
        },
        onExitFullScreen: () async {
         
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Future.delayed(const Duration(milliseconds: 200), () {
    provider.setFullScreen(false);
  });
        },
        player: YoutubePlayer(
          key: ValueKey(provider.isFullScreen),
          controller: yt,
          showVideoProgressIndicator: true,
          topActions: const [],
        ),
        builder: (context, player) => Stack(
          children: [
            Positioned.fill(child: player),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: kToolbarHeight,
              child: IgnorePointer(
                child: Container(color: AppColors.darkBlackColor),
              ),
            ),
          ],
        ),
      );
    }

    if (chewie != null) {
      return Chewie(controller: chewie);
    }

    return const Center(
      child: Text(
        'Error loading video',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildPlaceholder(Color prim) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlackColor,
            AppColors.darkBlackColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_outline,
            color: prim.withValues(alpha: 0.7),
            size: 64,
          ),
          const SizedBox(height: 8),
          Text(
            'Select a video to play',
            style: AppTextStyles.s15M.copyWith(
              color: Colors.white70,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
