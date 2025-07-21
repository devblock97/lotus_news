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
  await init();
  runApp(const App());
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
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social News',
          style: theme.appBarTheme.titleTextStyle
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NewsScreen(),
      resizeToAvoidBottomInset: true,
    );
  }
}
