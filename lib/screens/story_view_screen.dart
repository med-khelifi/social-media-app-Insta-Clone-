import 'package:flutter/material.dart';
import 'package:insta/controllers/story_view_screen_controller.dart';
import 'package:insta/core/models/story.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key});
  
  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late StoryViewScreenController _controller;
  late List<StoryModel> stories;
  @override
  void initState() {
    super.initState();
    _controller = StoryViewScreenController();
  }

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    stories = ModalRoute.of(context)!.settings.arguments as List<StoryModel>;
  }

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = stories.map((story) {
      if (story.isVideo) {
        return StoryItem.pageVideo(
          story.contentUrl,
          controller: _controller.storyController, 
        );
      } else {
        return StoryItem.pageImage(
          url: story.contentUrl,
          controller: _controller.storyController,
        );
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StoryView(
          storyItems: storyItems,
          controller: _controller.storyController,
          repeat: false,
          onComplete: () {
            Navigator.pop(context); // ترجع تلقائياً بعد انتهاء الستوري
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
