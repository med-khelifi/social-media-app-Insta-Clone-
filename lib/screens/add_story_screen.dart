import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta/controllers/add_new_story_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:video_player/video_player.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  late AddNewStoryScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddNewStoryScreenController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text("Add New Story"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                // TODO: Add upload story logic
              },
              child: Text(
                "Add",
                style: TextStyle(color: ColorsManager.blue, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<(bool, dynamic)?>(
          stream: _controller.fileStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: GestureDetector(
                  onTap: () => _controller.onImagePressed(context),
                  child: Image.asset(ImagesPaths.selectStory),
                ),
              );
            }

            final (isImage, data) = snapshot.data!;
            if (isImage) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(
                      File(data),
                      fit: BoxFit.cover,
                    ),
                  ),
                  _buildReSelectButton(context),
                ],
              );
            } else {
              final controller = data as VideoPlayerController;
              return Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  _buildReSelectButton(context),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildReSelectButton(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        backgroundColor: ColorsManager.blue,
        onPressed: () => _controller.onImagePressed(context),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
