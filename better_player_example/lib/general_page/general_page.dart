import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class GeneralPage extends StatefulWidget {
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  List dataSourceList = List<BetterPlayerDataSource>();

  Future<List<BetterPlayerDataSource>> setupData() async {
    await _saveAssetToFile();

    final directory = await getApplicationDocumentsDirectory();

    dataSourceList.add(BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        subtitlesFile: File("${directory.path}/example_subtitles.srt")));
    dataSourceList.add(BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"));
    dataSourceList.add(BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8",
        liveStream: true));

    return dataSourceList;
  }

  Future _saveAssetToFile() async {
    String content =
        await rootBundle.loadString("assets/example_subtitles.srt");
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/example_subtitles.srt");
    file.writeAsString(content);
    print("File created $file");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BetterPlayerDataSource>>(
      future: setupData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Building!");
        } else {
          return AspectRatio(
            child: BetterPlaylist(
              betterPlayerSettings: BetterPlayerSettings(
                  autoPlay: false,
                  autoInitialize: true,
                  subtitlesConfiguration:
                      BetterPlayerSubtitlesConfiguration(fontSize: 10),
                  controlsConfiguration:
                      BetterPlayerControlsConfiguration.cupertino()),
              betterPlayerPlaylistSettings:
                  const BetterPlayerPlaylistSettings(),
              betterPlayerDataSourceList: snapshot.data,
            ),
            aspectRatio: 16 / 9,
          );
        }
      },
    );
  }
}