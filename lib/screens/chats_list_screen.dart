import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/routes.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Chats"),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              onTap: () {
                Navigator.pushNamed(context, RoutesNames.messages);
              },
              leading: CircleAvatar(
                radius: 32.r,
                backgroundImage: NetworkImage(
                  "https://sfo2.digitaloceanspaces.com/harvard-law-library-nuremberg-authors/155-adolf-hitler.jpeg",
                ),
              ),
              title: Text("Khelifi Mohammed"),
              subtitle: Text(
                "last message Khelifi Mohammed",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            );
          },
        ),
      ),
    );
  }
}
