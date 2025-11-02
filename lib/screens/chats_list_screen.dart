import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/controllers/chats_controller.dart';
import 'package:insta/core/models/chat.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  late final ChatsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Chats"),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _controller.getCurrentUserChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No chats yet"));
            }

            final chats = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index]['chat'] as ChatModel;
                final receiverId = chats[index]['receiverId'];
                final receiverName = chats[index]['receiverName'];
                final receiverImage = chats[index]['receiverImage'];

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesNames.messages,
                      arguments: {
                        'receiverId': receiverId,
                        'receiverName': receiverName,
                        'receiverImage': receiverImage,
                      },
                    );
                  },
                  leading: CircleAvatar(
                    radius: 32.r,
                    backgroundImage: (receiverImage != null &&
                            receiverImage.isNotEmpty)
                        ? NetworkImage(receiverImage)
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                  ),
                  title: Text(receiverName),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
