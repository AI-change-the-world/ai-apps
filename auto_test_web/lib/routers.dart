import 'package:auto_test_web/pages/admin_main/admin_main_page.dart';
import 'package:auto_test_web/pages/login/login_page.dart';
import 'package:auto_test_web/pages/main/main_page.dart';
import 'package:flutter/material.dart';

class Routers {
  static const pageLogin = "pageLogin";
  static const pageMain = "pageMain";
  static const pageAdmin = "pageAdmin";

  static final Map<String, WidgetBuilder> routers = {
    pageLogin: (ctx) => LoginPage(),
    pageMain: (ctx) => const MainPage(),
    pageAdmin: (ctx) => const AdminMainPage(),
  };
}
