import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtherPage extends StatefulWidget {
  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      subtitles: BetterPlayerSubtitlesSource.single(
        type: BetterPlayerSubtitlesSourceType.NETWORK,
        url:
            "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt",
      ),
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        controlsConfiguration:
            BetterPlayerControlsConfiguration(enableProgressText: true),
      ),
    );
    _betterPlayerController.addEventsListener((event) {
      print("Better player event: ${event.betterPlayerEventType}");
    });
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(bottomOpacity: 0,),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BetterPlayer.network(
              "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
              betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: 9 / 16,
                fullScreenAspectRatio: 9 / 16,
                allowedScreenSleep: false,
                deviceOrientationsOnFullScreen: [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown
                ],
                controlsConfiguration: BetterPlayerControlsConfiguration(
                  overflowMenuCustomItems: [
                    BetterPlayerOverflowMenuItem(
                      Icons.account_circle_rounded,
                      "Custom element",
                      () {
                        print("Click!");
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    ));
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
}
