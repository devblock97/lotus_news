import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tma_news/core/theme/app_color.dart';
import 'package:tma_news/core/theme/theme_mode_provider.dart';
import 'package:tma_news/features/news/presentation/view/news_screen.dart';
import 'package:tma_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:tma_news/injector.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await init();
  runApp(const App());
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: Consumer<ThemeModeProvider>(
        builder: (_, theme, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.mode,
            debugShowCheckedModeBanner: false,
            home: const MainScreen()
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social News',
          style: theme.appBarTheme.titleTextStyle
        ),
        leading: Container(
          width: 25,
          height: 25,
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/images/news_logo.png',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.luminosity,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        // actions: [
        //   Consumer<ThemeModeProvider>(
        //     builder: (BuildContext context, ThemeModeProvider value, Widget? child) {
        //       return Switch(
        //           value: value.mode == ThemeMode.dark,
        //           onChanged: (value) {
        //             context.read<ThemeModeProvider>().toggle();
        //           }
        //       );
        //     },
        //   )
        // ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NewsScreen(),
      resizeToAvoidBottomInset: true,
    );
  }
}
