import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/posts_tab_controller.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/screens/home/widgets/post_tab_header.dart';
import 'package:insta/screens/home/widgets/post_widget.dart';
import 'package:insta/screens/home/widgets/stories_section.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  late PostsTabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PostsTabController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PostTabHeader(
            onMessageIconPressed: () => _controller.goToMessageScreen(context),
          ),
          StoriesSections(
            storiesStream: _controller
                .getStoriesForCurrentUserAndFollowingsStream(),
          ),
          VerticalSpace(10.h),
          StreamBuilder(
            stream: _controller.postsStream,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('error : ${asyncSnapshot.error}')),
                  );
                });
                return Center(child: Text('Error loading posts'));
              } else if (!asyncSnapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('error : empty response')),
                  );
                });
                return Center(child: Text('No posts'));
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: PostWidget(
                        onCommentIconPressed: () =>
                            _controller.onCommentIconPressed(
                              context,
                              asyncSnapshot.data![index].id,
                            ),
                        post: asyncSnapshot.data![index],
                        onLikeIconPressed: () => _controller.toggleLike(
                          asyncSnapshot.data![index].id,
                        ),
                        likeIconColor: _controller.getLikeIconColor(
                          asyncSnapshot.data![index].likes,
                        ),
                        showDeleteIcon: _controller.showDeleteIcon(
                          asyncSnapshot.data![index].userId,
                        ),
                        deletePostPressed: () => _controller.deletePost(
                          context,
                          asyncSnapshot.data![index].userId,
                          asyncSnapshot.data![index].imageUrl,
                        ),
                        onProfileIconPressed: () =>
                            _controller.onProfileIconPressed(
                              context,
                              asyncSnapshot.data![index].userId,
                            ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: asyncSnapshot.data?.length,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
