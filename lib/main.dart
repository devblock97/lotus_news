import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tma_news/core/components/profile_button_app_bar.dart';
import 'package:tma_news/core/constants/app_constants.dart';
import 'package:tma_news/core/theme/theme_mode_provider.dart';
import 'package:tma_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:tma_news/features/news/presentation/view/news_screen.dart';
import 'package:tma_news/features/search/presentation/view_model/search_view_model.dart';
import 'package:tma_news/injector.dart';

import 'core/theme/app_theme.dart';
import 'features/profile/presentation/view/profile_view.dart';
import 'features/search/presentation/view/search_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel())
      ],
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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          sliverAppBar(context),
          SliverToBoxAdapter(child: NewsScreen(),)
        ],
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text(
        'Social News',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold),),
      leading: _isSearching ? null : Container(
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
          }
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
          },
          child: ProfileButtonAppBar()
        ),
      ],
      centerTitle: true,
      backgroundColor: Colors.blueAccent.shade700,
      pinned: true,
      stretch: true,
      floating: true,
      expandedHeight: size.height * 0.12 + 20,
      flexibleSpace: categories(),
    );
  }

  Widget categories() {
    return FlexibleSpaceBar(
      background: Container(
        margin: EdgeInsets.only(top: size.height * 0.12 + 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AppConstants.categories.map((c) => Container(
              height: size.height * 0.04,
              margin: const EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.015),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.white),
                  top: BorderSide(color: Colors.white),
                  right: BorderSide(color: Colors.white),
                  bottom: BorderSide(color: Colors.white),
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Center(child: Text(c, style: TextStyle(color: Colors.white),)),)
            ).toList(),
          )],
        ),
      ),
    );
  }
}