import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoSwiper extends StatefulWidget {
  VideoSwiper({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VideoSwiperState createState() => new _VideoSwiperState();
}

class _VideoSwiperState extends State<VideoSwiper> {
  BetterPlayerController _betterPlayerController;
  StreamController<bool> _fileVideoStreamController =
      StreamController.broadcast();

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/zawarudo.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Swiper"),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return new
                    // Image.network(
                    //   "http://via.placeholder.com/288x188",
                    //   fit: BoxFit.fill,
                    // );
                    //                 StreamBuilder<bool>(
                    //   stream: _fileVideoStreamController.stream,
                    //   builder: (context, snapshot) {
                    //     if (snapshot?.data == true) {
                    //       return FutureBuilder<BetterPlayerController>(
                    //         future: _setupFileVideoDataSource(),
                    //         builder: (context, snapshot) {
                    //           if (!snapshot.hasData) {
                    //             return Center(child: CircularProgressIndicator());
                    //           } else {
                    //             return AspectRatio(
                    //               aspectRatio: 16 / 9,
                    //               child: BetterPlayer(
                    //                 controller: snapshot.data,
                    //               ),
                    //             );
                    //           }
                    //         },
                    //       );
                    //     } else {
                    //       return const SizedBox();
                    //     }
                    //   },
                    // );
                    //     BetterPlayer.network(
                    //   "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
                    //   betterPlayerConfiguration: BetterPlayerConfiguration(
                    //     aspectRatio: 9 / 16,
                    //   ),
                    // );
                    VideoPlayer(_controller);
              },
              itemCount: 10,
              viewportFraction: 0.8,
              scale: 0.9,
              pagination: new SwiperPagination(
                  builder: SwiperPagination.fraction,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              control: new SwiperControl(
                  iconNext: Icons.navigate_next_rounded,
                  iconPrevious: Icons.navigate_before_rounded,
                  size: 125),
              loop: false,
            )));
  }

  Future<BetterPlayerController> _setupFileVideoDataSource() async {
    await _saveAssetVideoToFile();
    final directory = await getApplicationDocumentsDirectory();

    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.FILE,
      "${directory.path}/zawarudo.mp4",
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(looping: true),
      betterPlayerDataSource: dataSource,
    );

    return _betterPlayerController;
  }

  Future _saveAssetVideoToFile() async {
    var content = await rootBundle.load("assets/zawarudo.mp4");
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/zawarudo.mp4");
    file.writeAsBytesSync(content.buffer.asUint8List());
  }
}
