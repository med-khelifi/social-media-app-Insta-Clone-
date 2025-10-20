import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';

class AddNewPostTab extends StatelessWidget {
  const AddNewPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              onPressed: () {},
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
        Image(
          image: AssetImage(ImagesPaths.placeholder),
          height: 300.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        TextField(
          maxLines: 10,
          decoration: InputDecoration(
            hintText: Strings.writeCaption,
            contentPadding: EdgeInsets.all(12.h),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
