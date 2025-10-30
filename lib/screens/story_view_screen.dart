import 'package:flutter/material.dart';
import 'package:insta/controllers/story_view_screen_controller.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late StoryViewScreenController _controller;
  @override
  void initState() {
    super.initState();
    _controller = StoryViewScreenController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StoryView(
          storyItems: [
            StoryItem(
              Image.network(
                "https://www.annefrank.org/media/filer_public_thumbnails/filer_public/88/ca/88ca45d2-50c5-400c-afa6-f8755d8f84fb/hitler_speer_y_breker_en_paris_23_de_junio_de_1940.jpg__1536x1536_q85_subsampling-2.jpg",
                fit: BoxFit.fill,
              ),
              duration: Duration(seconds: 3),
            ),
            StoryItem(
              Image.network(
                "https://histoire-image.org/sites/default/files/2022-05/visite-hitler-paris_0.jpg",
                fit: BoxFit.fill,
              ),
              duration: Duration(seconds: 6),
            ),
            StoryItem(
              Image.network(
                "https://instagram.ftun8-1.fna.fbcdn.net/v/t51.29350-15/418604304_753290686217449_4704796933862882781_n.jpg?stp=dst-jpg_e35_tt6&efg=eyJ2ZW5jb2RlX3RhZyI6InRocmVhZHMuRkVFRC5pbWFnZV91cmxnZW4uMTI4NHgxNTg0LnNkci5mMjkzNTAuZGVmYXVsdF9pbWFnZS5jMiJ9&_nc_ht=instagram.ftun8-1.fna.fbcdn.net&_nc_cat=101&_nc_oc=Q6cZ2QG-lOqBMQs93faiwv5z5QRt9s0jtrNB6YPFb6M7q9rxPCSvTvNx7f4WYp5TDDc3gPg&_nc_ohc=RVgzdJnCpZoQ7kNvwEXLJyU&_nc_gid=K7yilSpO7IEJLnYFy6oe6g&edm=AKr904kBAAAA&ccb=7-5&ig_cache_key=MzI3OTM5ODc4NDUwMjc1MjMyMw%3D%3D.3-ccb7-5&oh=00_AffyM97F6c3wiGM8GNL1Ma0BAbo7mNNW7rcZm88lOBv_cQ&oe=690931F7&_nc_sid=23467f",
                fit: BoxFit.fill,
              ),
              duration: Duration(seconds: 6),
            ),
            
          ],
          repeat: true,
          indicatorHeight: IndicatorHeight.small,
          controller: _controller.storyController,
        ),
      ),
    );
  }
}
