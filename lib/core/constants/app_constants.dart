class AppConstants {
  static String baseUrl = 'https://192.168.0.118:3000';
  static String token = '';

  static String news = '/api/news';

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