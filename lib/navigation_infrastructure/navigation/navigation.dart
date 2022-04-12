import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loops/navigation_infrastructure/navigation/bindings/controllers/task_view_binding.dart';
import 'package:loops/presentation/Backlog/views/taskview_view.dart';

import '../../presentation/Backlog/controllers/backlog.controller.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginControllerBinding(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.BACKLOG,
      page: () => BacklogScreen(),
      binding: BacklogControllerBinding(),
    ),
    GetPage(
      name: Routes.PROJECT_OVERVIEW,
      page: () => ProjectOverviewScreen(),
      binding: ProjectOverviewControllerBinding(),
    ),
    GetPage(
        name: Routes.TASK_VIEW,
        page: () => TaskviewView(),
        binding: TaskViewBinding())
  ];
}
