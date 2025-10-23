import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: TextField(
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
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(backgroundColor: ColorsManager.grey),
                title: Text('Username $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
