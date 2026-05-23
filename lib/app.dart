import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:velvet/routes/app_routes.dart';
import 'package:velvet/routes/routes_name.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      getPages: AppRoutes.routes,
      initialRoute: RoutesName.splash,
    );
  }
}
