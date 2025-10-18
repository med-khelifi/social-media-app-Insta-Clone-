import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/routes.dart';

class Insta extends StatelessWidget {
  const Insta({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72, 807.27),
      child: MaterialApp(
        routes: Routes.routes,
        initialRoute: RoutesNames.home,
        theme: ThemeData.dark(),
      ),
    );
  }
}
