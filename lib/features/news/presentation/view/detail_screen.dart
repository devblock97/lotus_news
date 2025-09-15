import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/theme/app_color.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/assistant_view_model.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_voice_view_model.dart';
import 'package:lotus_news/features/news/presentation/widgets/voice_wave.dart';

import '../widgets/summarize_button.dart';
import '../widgets/summarize_content.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.news});
  
  final NewsModel news;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {

  bool isPlaying = false;
  final Random _random = Random();
  List<double> _amplitudes = List.generate(40, (index) => Random().nextDouble() * 0.8);
  late AnimationController _voiceController;

  @override
  void initState() {
    super.initState();
    context.read<NewsVoiceViewModel>().setLanguage('en-US');
    _voiceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(() {
        _updateWave();
    });
  }

  void _updateWave() {
    setState(() {
      _amplitudes = List.generate(40, (_) => _random.nextDouble() * 0.8);
    });
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined))
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildHeader(theme),
          const SizedBox(height: 15,),
          Text(widget.news.summary ?? '', style: theme.textTheme.titleSmall,),
          _buildImage(size),
          Text(widget.news.title, style: theme.textTheme.titleSmall,),
          const SizedBox(height: 5,),
          _buildVoice(theme, widget.news.content ?? ''),
          const SizedBox(height: 5,),
          Consumer<AssistantViewModel>(
            builder: (_, state, child) {
              switch (state.state) {
                case SummaryStreaming data:
                  return AnimatedGradientBorder(
                    text: state.streamedText,
                    isStreaming: data.data.done ?? false
                  );
                case SummaryLoading _:
                  return const Center(child: CircularProgressIndicator(),);
                case SummaryError _:
                  return const Center(child: Text('Something went wrong'),);
                default:
                  return SummarizeAnimatedButton(
                    onPressed: () {
                      if (widget.news.content != null) {
                        context.read<AssistantViewModel>().summaryStream(widget.news.content!);
                      }
                    },
                  );
              }
            },
          ),
          const SizedBox(height: 5,),
          Text(widget.news.content?.trim() ?? '', style: theme.textTheme.bodySmall,)
        ],
      ),
      bottomNavigationBar: _buildBottomReact(theme),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: theme.primaryColor),
                  top: BorderSide(color: theme.primaryColor),
                  right: BorderSide(color: theme.primaryColor),
                  bottom: BorderSide(color: theme.primaryColor),
                )
              ),
              child: CachedNetworkImage(
                imageUrl: widget.news.brandIcon ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.fitHeight,
              )
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.news.body, style: theme.textTheme.titleSmall,),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: theme.textTheme.labelSmall,
                )
              ],
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blueAccent.shade700,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Text(
            'Following',
            style: theme.textTheme.titleSmall!.copyWith(
                color: AppColor.white
            )
          ),
        )
      ],
    );
  }

  Widget _buildImage(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0',
          height: size.height * 0.3,
          fit: BoxFit.cover,
        )
      ),
    );
  }

  Widget _buildVoice(ThemeData theme, String content) => Consumer<NewsVoiceViewModel>(
    builder: (_, state, child) {
      if (state.state == TtsState.playing && state.isDifferent(widget.news)) {
        _voiceController.repeat();
      } else {
        _voiceController.stop();
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: theme.primaryColor),
              top: BorderSide(color: theme.primaryColor),
              right: BorderSide(color: theme.primaryColor),
              bottom: BorderSide(color: theme.primaryColor),
            )
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                if (state.state == TtsState.playing) {
                  context.read<NewsVoiceViewModel>().pause();
                  _voiceController.stop();
                }

                if (state.state == TtsState.paused || state.state == TtsState.stopped) {
                  context.read<NewsVoiceViewModel>().speak(content);
                  context.read<NewsVoiceViewModel>().setNews(widget.news);
                  _voiceController.repeat();
                }
              },
              icon: Icon(
                (state.state == TtsState.playing && state.isDifferent(widget.news))
                  ? Icons.pause
                  : Icons.play_arrow,
                color: theme.primaryColor, size: 25,
              )
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: SizedBox(
                height: 50,
                width: double.maxFinite,
                child: CustomPaint(
                  painter: VoiceWavePainter(
                  amplitudes: _amplitudes,
                  color: Colors.blueAccent.shade700),
                ),
              )
            ),
            const SizedBox(width: 10,),
            IconButton(
              onPressed: () {
                context.read<NewsVoiceViewModel>().stop();
                _voiceController.stop();
              },
              icon: ((state.state == TtsState.playing || state.state == TtsState.paused) && state.isDifferent(widget.news))
                  ? Icon(Icons.stop, color: Colors.redAccent, size: 25,)
                  : const SizedBox.shrink()
            ),
          ],
        ),
      );
    },
  );

  Widget _buildBottomReact(ThemeData theme) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: theme.cardTheme.color!,
                blurRadius: 2,
                spreadRadius: 2
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.favorite_outline, color: theme.iconTheme.color,),
              const SizedBox(width: 5,),
              Text('12.3.K')
            ],
          ),
          const SizedBox(width: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.comment_outlined, color: theme.iconTheme.color,),
              const SizedBox(width: 5,),
              Text('1.1K bình luận')
            ],
          ),
          const Spacer(),
          Icon(Icons.bookmark_border_outlined, color: theme.iconTheme.color),
        ],
      ),
    );
  }

}