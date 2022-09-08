import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'controllers/setting_controller.dart';
import 'views/launch/launch_view.dart';
import 'views/login/forgot_password_view.dart';
import 'views/login/login_view.dart';
import 'views/login/sign_up_view.dart';
import 'views/main_tab/bottom_navigation_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.none:
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LauchView(),
            );
          case ConnectionState.done:
            return AnimatedBuilder(
              animation: SettingController.instance,
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'GoRoom',
                  theme: ThemeData(fontFamily: 'Poppins'),
                  locale: SettingController.instance.locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const MainTabView(),
                    '/signIn': (context) => LoginView(),
                    '/signUp': (context) => SignUpView(),
                    '/forgotPassword': (context) => ForgotPasswordView(),
                  },
                );
              },
            );
        }
      },
    );
  }
}
