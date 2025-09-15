class AppConstants {
  static String baseUrl = 'http://10.0.2.2:3000';
  static String token = '';

  static String posts = '/api/posts';

  static String search(String keyword) {
    return '/api/news/search?q=$keyword';
  }

  static String assistant = 'http://localhost:11434/api/generate';


  static List<String> categories = [
    'Tất cả', 'Thể thao', 'Chính trị',
    'Âm nhạc', 'Sự kiện', 'Công nghệ',
    'Khoa học', 'Giáo dục'
  ];

  static String baseLLMUrl = 'http://localhost:11434';
  static String llmToken = '';
}