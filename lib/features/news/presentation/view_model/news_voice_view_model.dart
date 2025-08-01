
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';

enum TtsState { playing, stopped, paused, continued }


class NewsVoiceViewModel extends ChangeNotifier {

  late FlutterTts flutterTts;

  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState _ttsState = TtsState.stopped;
  TtsState get state => _ttsState;

  late NewsModel _newsModel;

  void init() {
    flutterTts = FlutterTts();
    _setAwaitOptions();

    if (Platform.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    if (Platform.isIOS) {
      _setSharedAudio();
    }

    flutterTts.setStartHandler(() {
      print('Playing');
      _ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print('Complete');
      _ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print('Cancel');
      _ttsState = TtsState.stopped;
    });

    flutterTts.setPauseHandler(() {
      print('Paused');
      _ttsState = TtsState.paused;
    });

    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      print('Word: $word');
    });
    notifyListeners();
  }

  bool isDifferent(NewsModel latest) {
    if (news == null) return false;
    return news!.id == latest.id;
  }

  void setNews(NewsModel news) {
    _newsModel = news;
    notifyListeners();
  }

  NewsModel? get news => _newsModel;

  Future<void> _setSharedAudio() async {
    await flutterTts.setSharedInstance(true);
  }

  Future<void> _getDefaultEngine() async {
    await flutterTts.getDefaultEngine;
  }

  Future<void> _getDefaultVoice() async {
    await flutterTts.getDefaultVoice;
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> setLanguage(String language) async {
    await flutterTts.setLanguage(language);
  }

  Future<void> speak(String content) async {
    _ttsState = TtsState.playing;
    notifyListeners();

    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.speak(content);
  }

  Future<void> stop() async {
    var result = await flutterTts.stop();
    _ttsState = TtsState.stopped;
    notifyListeners();
  }


  Future<void> pause() async {
    var result = await flutterTts.pause();
    _ttsState = TtsState.paused;
    notifyListeners();
  }

}