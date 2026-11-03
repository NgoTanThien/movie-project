import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie/models/movie_detail.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final MovieDetail movieDetail;
  final int initialEpisodeIndex;

  VideoPlayerScreen({super.key, required this.movieDetail, this.initialEpisodeIndex = 0});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? controller;
  bool isLoading = true;
  bool hasError = false;
  String error = "";
  bool isPlaying = false;
  bool showControls = true;
  bool isFullScreen = false;
  int currentEpisodeIndex = 0;
  Timer? hideControlsTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
            children: [
              _buildVideoArea(),
              if(showControls)
                _buildHeader()
            ],
          )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentEpisodeIndex = widget.initialEpisodeIndex;
    loadVideo();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> loadVideo() async{
    try{
      String videoUrl = widget
          .movieDetail
          .episodes[0]
          .serverData[currentEpisodeIndex]
          .linkM3u8;
      controller?.dispose();
      controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl)
      );

      await controller!.initialize();
      controller!.play();
      controller!.addListener(videoListener);
      setState(() {
        isLoading = false;
        hasError = false;
        isPlaying = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        error = "Không thể phát video";
      });
    }
  }

  void videoListener(){
    if(controller == null){
      return;
    }
    bool playing = controller!.value.isPlaying;
    if(isPlaying != playing){
      setState(() {
        isPlaying = playing;
      });
    }
  }

  void togglePlayPause(){
    if(controller == null){
      return;
    }

    if(controller!.value.isPlaying){
      controller!.pause();
    }else{
      controller!.play();
    }
  }

  void toggleControls(){
    setState(() {
      showControls = !showControls;
    });

    if(showControls){
      startHideControlsTimer();
    }
  }

  void startHideControlsTimer(){
    hideControlsTimer?.cancel();
    hideControlsTimer = Timer(
      Duration(seconds: 3),
      () {
        setState(() {
            showControls = false;
        });
      },
    );
  }

  void toggleFullScreen() async {
    if(isFullScreen){
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge
      );

      await SystemChrome.setPreferredOrientations(
        DeviceOrientation.values
      );
    } else {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }

    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  void changeEpisode(int index){
    setState(() {
      currentEpisodeIndex = index;
      isLoading = true;
    });

    loadVideo();

  }

  String formatDuration(Duration duration){
    String twoDigits(int n){
      return n.toString().padLeft(2,'0');
    }
    String hour = twoDigits(duration.inHours);
    String minute = twoDigits(duration.inMinutes.remainder(60));
    String second = twoDigits(duration.inSeconds.remainder(60));
    return "$hour:$minute:$second";
  }

  Widget _buildVideoArea(){
    return GestureDetector(
      onTap: toggleControls,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if(controller !=null && controller!.value.isInitialized)
              AspectRatio(
                  aspectRatio: controller!
                      .value
                      .aspectRatio,
                  child: VideoPlayer(
                    controller!
                  ),
              ),
            if(isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.red,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Đang tải video...",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            if(hasError)
              Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            if(showControls && controller != null && controller!.value.isInitialized)
              _buildControls()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.black54,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )
              ),
              Expanded(
                  child: Text(
                    widget.movieDetail.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
              )
            ],
          ),
        )
    );
  }

  Widget _buildControls(){
    return Column(
      mainAxisAlignment: .end,
      children: [
        Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  IconButton(
                      onPressed: () {
                        Duration current = controller!.value.position;
                        controller!.seekTo(
                         current - Duration(seconds: 10)
                        );
                      },
                      icon: Icon(
                        Icons.replay_10,
                        color: Colors.white,
                        size: 35,
                      )
                  ),
                  SizedBox(width: 20,),
                  IconButton(
                      onPressed: togglePlayPause,
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: Colors.white,
                        size: 70,
                      )
                  ),
                  SizedBox(width: 20,),
                  IconButton(
                      onPressed: () {
                        Duration current = controller!.value.position;
                        controller!.seekTo(
                          current + Duration(seconds: 10)
                        );
                      },
                      icon: Icon(
                        Icons.forward_10,
                        color: Colors.white,
                        size: 35,
                      )
                  )
                ],
              ),
            )
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Colors.black54,
          child: SingleChildScrollView(
            child: Column(
              children: [
                VideoProgressIndicator(
                    controller!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white24
                    ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      formatDuration(controller!.value.position),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Text(
                      " / ",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Text(
                      formatDuration(controller!.value.duration),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: toggleFullScreen,
                        icon: Icon(
                          isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                          color: Colors.white,
                        )
                    )
                  ],
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
        )
      ],
    );
  }
}
