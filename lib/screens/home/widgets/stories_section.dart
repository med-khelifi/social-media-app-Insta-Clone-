import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/models/story.dart';

class StoriesSections extends StatelessWidget {
  const StoriesSections({super.key, required this.storiesStream});

  final Stream<Map<String, List<StoryModel>>> storiesStream;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: StreamBuilder<Map<String, List<StoryModel>>>(
        stream: storiesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No stories yet"));
          }

          final storiesMap = snapshot.data!;
          final userIds = storiesMap.keys.toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            separatorBuilder: (_, __) => HorizontalSpace(8.w),
            itemCount: userIds.length,
            itemBuilder: (context, index) {
              final userId = userIds[index];
              final userStories = storiesMap[userId]!;
              final firstStory = userStories.first;

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesNames.storyView,
                    arguments: userStories,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.pink, width: 3.w),
                        image: DecorationImage(
                          image: firstStory.imageUrl.isEmpty
                              ? AssetImage(ImagesPaths.placeholder)
                              : NetworkImage(firstStory.imageUrl) as ImageProvider,
                          fit: BoxFit.cover, 
                        ),
                      ),
                    ),
                    Text(firstStory.username)
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
