import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class VideoSwiper extends StatefulWidget {
  VideoSwiper({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VideoSwiperState createState() => new _VideoSwiperState();
}

class _VideoSwiperState extends State<VideoSwiper> {
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
                BetterPlayer.network("https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4");
              },
              itemCount: 10,
              viewportFraction: 0.8,
              scale: 0.9,
              pagination: new SwiperPagination(builder: SwiperPagination.fraction, margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
              control: new SwiperControl(iconNext: Icons.navigate_next_rounded, iconPrevious: Icons.navigate_before_rounded, size: 125),
            )));
  }
}
