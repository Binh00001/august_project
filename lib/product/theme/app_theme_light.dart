import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeLight extends AppTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    _instance ??= AppThemeLight._init();
    return _instance!;
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => ThemeData.light().copyWith(
        colorScheme: _buildColorScheme,
      );

  ColorScheme get _buildColorScheme => const ColorScheme(
      brightness: Brightness.light,
      primary:
          Color(0xFF864AF9), // Màu hồng hơi tím, khá sáng, dùng làm màu chính
      onPrimary: Color(
          0xFFFFFFFF), // Màu trắng, dùng cho văn bản và icon trên nền màu chính
      secondary: Color(0xFF3B3486), // Màu xanh hơi đậm, dùng làm màu phụ
      onSecondary: Color(
          0xFFFFFFFF), // Màu trắng, dùng cho văn bản và icon trên nền màu phụ
      error: Colors.red, // Màu đỏ cho lỗi
      onError: Colors.white, // Màu trắng cho văn bản trên nền lỗi
      surface: Color(0xFF864AF9),
      // Color(0xFFFFE9B1), // Màu vàng nhẹ, sáng cho bề mặt các thành phần
      onSurface: Color(
          0xFF332941), // Màu tối nhất, dùng cho văn bản và icon trên bề mặt vàng
      background: Color(
          0xFFFFE9B1), // Màu vàng nhẹ cho nền của các màn hình/phần tử layout
      onBackground:
          Color(0xFF332941) // Màu tối nhất cho văn bản trên nền vàng nhẹ
      );
}
