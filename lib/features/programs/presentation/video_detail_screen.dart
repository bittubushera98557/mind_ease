import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';

/// Video Detail Screen with full video playback and thumbnail support using video_player
class VideoDetailScreen extends StatefulWidget {
  final PhaseVideoModel? video;
  final int videoNumber;
  final int totalVideos;
  final String videoTitle;
  final String videoDescription;
  final String duration;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final int videoCompletePercent;

  const VideoDetailScreen({
    Key? key,
    this.video,
    this.videoNumber = 1,
    this.totalVideos = 3,
    this.videoTitle = "Let's Redefine Mental Health",
    this.videoDescription =
        "Why mental health is something everyone has, not just a label for illness.",
    this.duration = "1:12",
    this.mediaUrl,
    this.thumbnailUrl,
    this.videoCompletePercent = 90,
  }) : super(key: key);

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isSeeking = false;
  bool _hasError = false;
  String _errorMessage = '';
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    final mediaUrl = widget.video?.mediaUrl?.isNotEmpty == true
        ? widget.video!.mediaUrl!
        : (widget.mediaUrl ?? '');

    if (mediaUrl.isNotEmpty) {
      try {
        _controller?.dispose();
        _controller = null;

        if (mediaUrl.startsWith('assets/') || mediaUrl.startsWith('asset/')) {
          _controller = VideoPlayerController.asset(mediaUrl);
        } else {
          final uri = Uri.tryParse(mediaUrl);
          if (uri != null && (uri.hasScheme || uri.host.isNotEmpty)) {
            _controller = VideoPlayerController.networkUrl(uri);
          } else {
            _controller = VideoPlayerController.networkUrl(Uri.parse(mediaUrl));
          }
        }

        if (_controller != null) {
          _controller!.initialize().then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
                _hasError = false;
                _errorMessage = '';
              });
            }
          }).catchError((error) {
            debugPrint('VideoPlayer initialization error: $error');
            if (mounted) {
              setState(() {
                _isInitialized = false;
                _hasError = true;
                _errorMessage = 'Unable to play video stream. Please check connection.';
              });
            }
          });

          _controller!.addListener(_videoPlayerListener);
        }
      } catch (e) {
        debugPrint('VideoPlayer setup error: $e');
        if (mounted) {
          setState(() {
            _isInitialized = false;
            _hasError = true;
            _errorMessage = 'Failed to setup video player.';
          });
        }
      }
    }
  }

  void _videoPlayerListener() {
    if (!mounted || _controller == null) return;

    final value = _controller!.value;
    if (!_isSeeking && value.isInitialized && value.duration.inMilliseconds > 0) {
      final progress =
          value.position.inMilliseconds / value.duration.inMilliseconds;
      setState(() {
        _sliderValue = progress.clamp(0.0, 1.0);
        _isPlaying = value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoPlayerListener);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        setState(() => _isPlaying = false);
      } else {
        _controller!.play();
        setState(() => _isPlaying = true);
      }
    } else {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _replayVideo() {
    if (_controller != null && _isInitialized) {
      _controller!.seekTo(Duration.zero);
      _controller!.play();
      setState(() {
        _sliderValue = 0.0;
        _isPlaying = true;
      });
    } else {
      setState(() {
        _sliderValue = 0.0;
        _isPlaying = false;
      });
    }
  }

  void _seekToRatio(double ratio) {
    setState(() {
      _sliderValue = ratio;
    });
    if (_controller != null &&
        _isInitialized &&
        _controller!.value.duration.inMilliseconds > 0) {
      final targetMs =
          (ratio * _controller!.value.duration.inMilliseconds).toInt();
      _controller!.seekTo(Duration(milliseconds: targetMs));
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final effectiveTitle = video?.title.isNotEmpty == true
        ? video!.title
        : widget.videoTitle;
    final effectiveDescription = video?.description?.isNotEmpty == true
        ? video!.description!
        : widget.videoDescription;
    final effectiveMediaUrl = video?.mediaUrl?.isNotEmpty == true
        ? video!.mediaUrl
        : widget.mediaUrl;
    final effectiveThumbnailUrl = video?.thumbnailUrl?.isNotEmpty == true
        ? video!.thumbnailUrl
        : widget.thumbnailUrl;

    // Determine current & total duration
    Duration durationObj = Duration.zero;
    if (_controller != null && _isInitialized) {
      durationObj = _controller!.value.duration;
    } else if (video?.duration != null && video!.duration > 0) {
      durationObj = Duration(seconds: video.duration);
    }

    String formattedDuration = widget.duration;
    if (durationObj.inSeconds > 0) {
      final mins = durationObj.inMinutes;
      final secs = (durationObj.inSeconds % 60).toString().padLeft(2, '0');
      formattedDuration = '$mins:$secs';
    }

    Duration positionObj = Duration.zero;
    if (_controller != null && _isInitialized) {
      positionObj = _controller!.value.position;
    } else if (durationObj.inSeconds > 0) {
      positionObj = Duration(seconds: (_sliderValue * durationObj.inSeconds).toInt());
    }

    final playedMins = positionObj.inMinutes;
    final playedSecs = (positionObj.inSeconds % 60).toString().padLeft(2, '0');
    final playedDurationStr = '$playedMins:$playedSecs';

    final int playedPercent = (durationObj.inSeconds > 0)
        ? ((positionObj.inSeconds / durationObj.inSeconds) * 100).toInt().clamp(0, 100)
        : (_sliderValue * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Back button & "VIDEO X OF Y"
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'VIDEO ${widget.videoNumber} OF ${widget.totalVideos}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
              const SizedBox(height: 16),

              // Video Player Banner / Thumbnail Container
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2420),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Gradient Fallback Background
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFB33A27), AppColors.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),

                      // Thumbnail Image
                      if (effectiveThumbnailUrl != null &&
                          effectiveThumbnailUrl.isNotEmpty)
                        Positioned.fill(
                          child: Image.network(
                            effectiveThumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),

                      // Video Player output when initialized
                      if (_isInitialized && _controller != null)
                        Positioned.fill(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: _controller!.value.size.width > 0
                                  ? _controller!.value.size.width
                                  : 640,
                              height: _controller!.value.size.height > 0
                                  ? _controller!.value.size.height
                                  : 360,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        ),

                      // Dark Overlay for controls readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(_isPlaying ? 0.15 : 0.35),
                                Colors.black.withOpacity(_isPlaying ? 0.35 : 0.65),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Loading indicator if initializing
                      if (_controller != null && !_isInitialized && !_hasError)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),

                      // Error message if initialization failed
                      if (_hasError)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage.isNotEmpty
                                      ? _errorMessage
                                      : 'Unable to play video',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _hasError = false;
                                    });
                                    _initializeVideoPlayer();
                                  },
                                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                                  label: Text(
                                    'Retry',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Center Play / Pause Button
                      Center(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(_isPlaying ? 0.85 : 1.0),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: AppColors.primary,
                              size: 34,
                            ),
                          ),
                        ),
                      ),

                      // Video Title & Duration overlay at bottom
                      Positioned(
                        left: 16,
                        bottom: 16,
                        right: 16,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                effectiveTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                formattedDuration,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Slider Scrubber
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: const Color(0xFFE8E2DA),
                  thumbColor: AppColors.primary,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: _sliderValue.clamp(0.0, 1.0),
                  onChangeStart: (_) => _isSeeking = true,
                  onChanged: (val) {
                    setState(() {
                      _sliderValue = val;
                    });
                  },
                  onChangeEnd: (val) {
                    _isSeeking = false;
                    _seekToRatio(val);
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Controls Row
              Row(
                children: [
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _replayVideo,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: const Icon(
                        Icons.replay_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$playedDurationStr / $formattedDuration',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                '$playedPercent% played · needs ${widget.videoCompletePercent}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 20),

              // Video Title & Description
              Text(
                effectiveTitle,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                effectiveDescription,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),

              // Media Stream Info Card
              if (effectiveMediaUrl != null && effectiveMediaUrl.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.ondemand_video_rounded,
                        size: 20,
                        color: Color(0xFF5A8F5A),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Media Stream URL',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              effectiveMediaUrl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (effectiveMediaUrl != null && effectiveMediaUrl.isNotEmpty)
                const SizedBox(height: 24),

              // Next Video Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next video',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
