class AppConstants {
  static String baseUrl = 'https://192.168.0.118:3000';
  static String token = '';

  static String news = '/api/news';

  static String search(String keyword) {
    return '/api/news/search?q=$keyword';
  }

  static List<String> categories = [
    'Tất cả', 'Thể thao', 'Chính trị',
    'Âm nhạc', 'Sự kiện', 'Công nghệ',
    'Khoa học', 'Giáo dục'
  ];
}