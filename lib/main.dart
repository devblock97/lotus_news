import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:lotus_news/features/news/presentation/widgets/post_stream.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/components/profile_button_app_bar.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/core/theme/theme_mode_provider.dart';
import 'package:lotus_news/features/assistant/data/model/chat_message.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/assistant_view_model.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/chat_view_model.dart';
import 'package:lotus_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lotus_news/features/news/presentation/view/detail_screen.dart';
import 'package:lotus_news/features/news/presentation/view/news_screen.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_voice_view_model.dart';
import 'package:lotus_news/features/news/presentation/widgets/voice_wave.dart';
import 'package:lotus_news/features/search/presentation/view_model/search_view_model.dart';
import 'package:lotus_news/injector.dart';

import 'core/theme/app_theme.dart';
import 'features/news/presentation/view_model/vote_view_model.dart';
import 'features/profile/presentation/view/profile_screen.dart';
import 'features/search/presentation/view/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  await Hive.openBox<ChatMessage>('chatBox');
  HttpOverrides.global = MyHttpOverrides();
  await init();
  runApp(const App());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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
        ChangeNotifierProvider(
          create: (_) =>
              AuthViewModel(injector(), injector(), injector(), injector()),
        ),
        ChangeNotifierProvider(create: (_) => NewsVoiceViewModel()..init()),
        ChangeNotifierProvider(create: (_) => AssistantViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(
          create: (_) => NewsViewModel(injector(), injector())..getNews(),
        ),
        ChangeNotifierProvider(create: (_) => VoteViewModel(injector())),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (_, theme, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.mode,
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
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

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final bool _isSearching = false;

  late AnimationController _voiceController;

  List<double> _amplitudes = List.generate(
    40,
    (_) => Random().nextDouble() * 0.8,
  );

  @override
  void initState() {
    super.initState();
    _voiceController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..addListener(() {
          updateWave();
        });
  }

  void updateWave() {
    setState(() {
      _amplitudes = List.generate(40, (_) => Random().nextDouble() * 0.8);
    });
  }

  @override
  void dispose() {
    _voiceController.dispose();
    context.read<NewsVoiceViewModel>().stop();
    super.dispose();
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
          SliverToBoxAdapter(child: PostStream()),
          SliverToBoxAdapter(child: NewsScreen()),
        ],
      ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _buildNewsQuickAction(theme),
    );
  }

  Widget _buildNewsQuickAction(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 24),
      child: Consumer<NewsVoiceViewModel>(
        builder: (context, state, child) {
          if (state.state == TtsState.playing) {
            _voiceController.repeat();
          } else {
            _voiceController.stop();
          }
          if (state.state == TtsState.playing ||
              state.state == TtsState.paused) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(news: state.news!),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: theme.primaryColor),
                    top: BorderSide(color: theme.primaryColor),
                    right: BorderSide(color: theme.primaryColor),
                    bottom: BorderSide(color: theme.primaryColor),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        state.news!.title,
                        style: theme.textTheme.labelSmall,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (state.state == TtsState.playing) {
                              context.read<NewsVoiceViewModel>().pause();
                              _voiceController.stop();
                            }
                            if (state.state == TtsState.paused ||
                                state.state == TtsState.stopped) {
                              // context.read<NewsVoiceViewModel>().speak(content);
                              _voiceController.repeat();
                            }
                          },
                          icon: Icon(
                            state.state == TtsState.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: theme.primaryColor,
                            size: 25,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0',
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: CustomPaint(
                              painter: VoiceWavePainter(
                                amplitudes: _amplitudes,
                                color: Colors.blueAccent.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            context.read<NewsVoiceViewModel>().stop();
                            _voiceController.stop();
                          },
                          icon:
                              state.state == TtsState.playing ||
                                  state.state == TtsState.paused
                              ? Icon(
                                  Icons.stop,
                                  color: Colors.redAccent,
                                  size: 25,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: _isSearching
          ? null
          : Container(
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
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          },
          child: ProfileButtonAppBar(),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AppConstants.categories
                  .map(
                    (c) => Container(
                      height: size.height * 0.04,
                      margin: const EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.height * 0.015,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white),
                          top: BorderSide(color: Colors.white),
                          right: BorderSide(color: Colors.white),
                          bottom: BorderSide(color: Colors.white),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(c, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
