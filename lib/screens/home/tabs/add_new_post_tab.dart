import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/add_new_post_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';

class AddNewPostTab extends StatefulWidget {
  const AddNewPostTab({super.key});

  @override
  State<AddNewPostTab> createState() => _AddNewPostTabState();
}

class _AddNewPostTabState extends State<AddNewPostTab> {
  late AddNewPostScreenController _controller ;
  @override
  void initState() {
    super.initState();
    _controller = AddNewPostScreenController();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                Strings.addNewPost,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _controller.handlePostUpload(context),
                child: Text(
                  Strings.next,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.h),
          StreamBuilder(
            stream: _controller.imageStream,
            builder: (context, asyncSnapshot) {
              return InkWell(
                onTap: _controller.takePhoto,
                child: Image(
                  image: asyncSnapshot.hasData ? FileImage(asyncSnapshot.data!) : AssetImage(ImagesPaths.placeholder),
                  height: 300.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            }
          ),
          TextField(
            controller: _controller.captionTextController,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: Strings.writeCaption,
              contentPadding: EdgeInsets.all(12.h),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
