import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/search_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/images_paths.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late SearchScreenController _controller;
  @override
  void initState() {
    super.initState();
    _controller = SearchScreenController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: TextField(
            controller: _controller.searchBoxEditingController,
            onChanged: (value) {
              setState(() {
                
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.r),
                borderSide: BorderSide(color: ColorsManager.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.r),
                borderSide: BorderSide(color: ColorsManager.blue),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _controller.getSearchedUsers(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text("error: ${asyncSnapshot.error}"));
              } else if (!asyncSnapshot.hasData) {
                return Center(child: Text("error: no data fetched"));
              } else {
                var data = asyncSnapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => _controller.onUserListTileItemPressed(context,data[index].uid),
                      leading: CircleAvatar(
                        backgroundImage:
                            data[index].profileImageUrl == null ||
                                data[index].profileImageUrl!.isEmpty
                            ? AssetImage(ImagesPaths.placeholder)
                            : NetworkImage(data[index].profileImageUrl!),
                      ),
                      title: Text(data[index].username),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
