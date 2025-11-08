import 'dart:io';

class AppConstants {
  static String baseUrl(bool isAndroid) {
    if (isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  static String wsUrl(bool isRealDevice) {
    if (isRealDevice) {
      return 'ws://192.168.110.223/api/ws/posts';
    } else {
      if (Platform.isAndroid) {
        return 'ws://10.0.2.2:3000/api/ws/posts';
      } else {
        return 'ws://localhost:3000/api/ws/posts';
      }
    }
  }

  static String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5NWE3YzljZi1hMDUyLTRiZmUtYmFjYy05NDBhMGU1NjA0MGUiLCJleHAiOjE3NjI3MDA3MTl9.oAWylG3o5ieAK0nEO6mDRE026F8gWACa0LKmgbq7_cU';

  static String posts = '/api/posts';
  static String voteNews(String postId) {
    return '/api/posts/$postId/vote';
  }

  static String search(String keyword) {
    return '/api/news/search?q=$keyword';
  }

  static String assistant = 'http://localhost:11434/api/generate';

  static List<String> categories = [
    'Tất cả',
    'Thể thao',
    'Chính trị',
    'Âm nhạc',
    'Sự kiện',
    'Công nghệ',
    'Khoa học',
    'Giáo dục',
  ];

  static String baseLLMUrl = 'http://localhost:11434';
  static String llmToken = '';
}
