import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/models/post.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.onCommentIconPressed,
    required this.post,
    required this.onLikeIconPressed,
    required this.likeIconColor,
    required this.showDeleteIcon,
    required this.deletePostPressed, required this.onProfileIconPressed,
  });
  final VoidCallback onCommentIconPressed;
  final VoidCallback onLikeIconPressed;
  final VoidCallback deletePostPressed;
  final VoidCallback onProfileIconPressed;
  final PostModel post;
  final Color likeIconColor;
  final bool showDeleteIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              InkWell(
                onTap: onProfileIconPressed,
                child: CircleAvatar(
                  backgroundImage:
                      post.userImage == null || post.userImage!.isEmpty
                      ? AssetImage(ImagesPaths.placeholder)
                      : NetworkImage(post.userImage!),
                ),
              ),
              HorizontalSpace(8.w),
              Text(post.username),
              const Spacer(),
              if (showDeleteIcon)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deletePostPressed,
                ),
            ],
          ),
        ),
        VerticalSpace(8.h),
        if (post.imageUrl.isNotEmpty)
          Image.network(post.imageUrl)
        else
          SizedBox(),
        VerticalSpace(4.h),
        Padding(
          padding: EdgeInsets.only(left: 10.h),
          child: Text(post.caption),
        ),
        VerticalSpace(4.h),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.favorite, color: likeIconColor),
              onPressed: onLikeIconPressed,
            ),
            HorizontalSpace(2.w),
            Text(post.likes.isEmpty ? "" : post.likes.length.toString()),
            IconButton(
              icon: const Icon(Icons.comment_outlined),
              onPressed: onCommentIconPressed,
            ),
            IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
