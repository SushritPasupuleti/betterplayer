import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:better_player_example/other_page/other_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class GeneralPage extends StatefulWidget {
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

/// Stream urls which can be used to test features:
///"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
// "https://mtoczko.github.io/hls-test-streams/test-group/playlist.m3u8",

class _GeneralPageState extends State<GeneralPage> {
  BetterPlayerController _betterPlayerController;
  StreamController<bool> _fileVideoStreamController =
      StreamController.broadcast();
  bool _fileVideoShown = false;
  int _count = 3;
  //bool _loop = true;

  Future<BetterPlayerController> _setupDefaultVideoData() async {
    var dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK,
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
        resolutions: {
          "LOW":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
          "MEDIUM":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4",
          "LARGE":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1280_10MG.mp4",
          "EXTRA_LARGE":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4"
        });
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          looping: true,
          //looping: _count == 0 ? false : true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
              //enableProgressText: true,
              //enablePlaybackSpeed: true,
              //enableSubtitles: true,
              ),
        ),
        betterPlayerDataSource: dataSource);
    _betterPlayerController.addEventsListener((event) {
      //print("Better player event: ${event.betterPlayerEventType}");

      if (event.betterPlayerEventType == BetterPlayerEventType.FINISHED) {
        debugPrint(
            "Finished Playing clip! ${TimeOfDay(hour: null, minute: null).minute} $_count");
        if (_count > 0) {
          setState(() {
            _count = _count - 1;
          });
          debugPrint("=============================================");
          debugPrint(
              "Finished Playing clip, $_count times remaining! ${TimeOfDay(hour: null, minute: null).minute}");
          debugPrint("=============================================");
          // if (_count == 0) {
          //   // setState(() {
          //   //   _loop = false;
          //   // });
          //   debugPrint("!=============================================!");
          //   debugPrint(
          //       "Finished Playing clip, $_count times! ${TimeOfDay(hour: null, minute: null).minute}");
          //   debugPrint("!=============================================!");
          //   _betterPlayerController.setLooping(false);
          // }
        }
        // if (_count == 0){
        //   setState(() {
        //     _loop = false;
        //   });
        //   debugPrint("=============================================");
        //   debugPrint("Finished Playing clip, $_count times remaining! ${TimeOfDay(hour: null, minute: null).minute}");
        //   debugPrint("=============================================");
        // }
      }
    });
    return _betterPlayerController;
  }

  Future<BetterPlayerController> _setupFileVideoData() async {
    await _saveAssetVideoToFile();
    await _saveAssetSubtitleToFile();
    final directory = await getApplicationDocumentsDirectory();

    int _count = 3;

    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.FILE,
      "${directory.path}/zawarudo.mp4",
      subtitles: BetterPlayerSubtitlesSource.single(
        type: BetterPlayerSubtitlesSourceType.FILE,
        url: "${directory.path}/example_subtitles.srt",
      ),
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(looping: true),
      betterPlayerDataSource: dataSource,
    );

    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.FINISHED) {
        debugPrint("!=============================================!");
        debugPrint(
            "Finished Playing clip! ${TimeOfDay(hour: null, minute: null).minute}");
        debugPrint("!=============================================!");
        // if (_count > 0) {
        //   setState(() {
        //     _count -= 1;
        //   });
        //   debugPrint("!=============================================!");
        //   debugPrint("Step No: $_count");
        //   debugPrint("!=============================================!");
        // }
      }
    });

    return _betterPlayerController;
  }

  Future _saveAssetSubtitleToFile() async {
    String content =
        await rootBundle.loadString("assets/example_subtitles.srt");
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/example_subtitles.srt");
    file.writeAsString(content);
  }

  Future _saveAssetVideoToFile() async {
    var content = await rootBundle.load("assets/zawarudo.mp4");
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/zawarudo.mp4");
    file.writeAsBytesSync(content.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.all(8),
        child: Text("This is example default video. This video is loaded from"
            " URL. Subtitles are loaded from file."),
      ),
      _buildDefaultVideo(),
      _buildShowFileVideoButton(),
      _buildOtherPageButton(),
    ]);
  }

  Widget _buildDefaultVideo() {
    return FutureBuilder<BetterPlayerController>(
      future: _setupDefaultVideoData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: snapshot.data,
            ),
          );
        }
      },
    );
  }

  Widget _buildShowFileVideoButton() {
    return Column(children: [
      RaisedButton(
        child: Text("Show video from file"),
        onPressed: () {
          _fileVideoShown = !_fileVideoShown;
          _fileVideoStreamController.add(_fileVideoShown);
        },
      ),
      _buildFileVideo()
    ]);
  }

  Widget _buildOtherPageButton() {
    return Column(children: [
      RaisedButton(
        child: Text("Show video in other page"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );
        },
      ),
    ]);
  }

  Widget _buildFileVideo() {
    return StreamBuilder<bool>(
      stream: _fileVideoStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot?.data == true) {
          return FutureBuilder<BetterPlayerController>(
            future: _setupFileVideoData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: snapshot.data,
                  ),
                );
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  void dispose() {
    _fileVideoStreamController.close();
    super.dispose();
  }
}
