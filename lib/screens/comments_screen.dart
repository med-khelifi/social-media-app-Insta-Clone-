import 'package:flutter/material.dart';
import 'package:insta/controllers/comments_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentsScreenController _controller;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map arg = ModalRoute.of(context)!.settings.arguments as Map;
    String postId = arg["postId"];
    _controller = CommentsScreenController(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.comments)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _controller.getPostComments(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading comments : ${asyncSnapshot.error}',
                    ),
                  );
                } else if (!asyncSnapshot.hasData) {
                  return const Center(child: Text('No comments yet'));
                } else {
                  var data = asyncSnapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              data[index].userImage.isEmpty ||
                                  data[index].userImage == ""
                              ? AssetImage(ImagesPaths.placeholder)
                              : NetworkImage(data[index].userImage),
                        ),
                        title: Text(
                          data[index].username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data[index].text),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_controller.showDeleteIcon(data[index].userId))
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _controller.deleteComment(
                                  context,
                                  data[index].id,
                                ),
                              ),
                            Text(
                              data[index].likes.isEmpty
                                  ? ""
                                  : data[index].likes.length.toString(),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: _controller.getLikeIconColor(
                                  data[index].likes,
                                ),
                              ),
                              onPressed: () =>
                                  _controller.toggleLike(data[index].id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      _controller.getCurrentUserImage(context) == null ||
                          _controller.getCurrentUserImage(context)!.isEmpty
                      ? AssetImage(ImagesPaths.placeholder)
                      : NetworkImage(_controller.getCurrentUserImage(context)!),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _controller.commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: ColorsManager.white),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _controller.addComment(context: context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
