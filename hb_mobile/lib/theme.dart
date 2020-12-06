import 'package:flutter/material.dart';

class MaterialDemoThemeData {
  static final themeData = ThemeData(
    colorScheme: _colorScheme,
    appBarTheme: AppBarTheme(
      color: _colorScheme.primary,
      iconTheme: IconThemeData(color: _colorScheme.onPrimary),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: _colorScheme.primary,
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: _colorScheme,
    ),
    canvasColor: _colorScheme.background,
    toggleableActiveColor: _colorScheme.primary,
    highlightColor: Colors.transparent,
    indicatorColor: _colorScheme.onPrimary,
    primaryColor: _colorScheme.primary,
    accentColor: _colorScheme.primary,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: _colorScheme.background,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    typography: Typography.material2018(
        // platform: defaultTargetPlatform,
        ),
  );

  static const _colorScheme = ColorScheme(
    primary: Color(0xFF263238),
    // primary: Color(0xFF344955),
    primaryVariant: Color(0xFF000a12),
    // primaryVariant: Color(0xFF0b222c),
    secondary: Color(0xFFfafafa),
    // secondary: Color(0xFFf9aa33),
    secondaryVariant: Color(0xFFc7c7c7),
    // secondaryVariant: Color(0xFF17b00),
    background: Colors.white,
    surface: Color(0xFFF2F2F2),
    onBackground: Colors.black,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    brightness: Brightness.light,
  );
// static const _colorScheme = ColorScheme(
//   primary: Color(0xFF6200EE),
//   primaryVariant: Color(0xFF6200EE),
//   secondary: Color(0xFFFF5722),
//   secondaryVariant: Color(0xFFFF5722),
//   background: Colors.white,
//   surface: Color(0xFFF2F2F2),
//   onBackground: Colors.black,
//   onSurface: Colors.black,
//   error: Colors.red,
//   onError: Colors.white,
//   onPrimary: Colors.white,
//   onSecondary: Colors.white,
//   brightness: Brightness.light,
// );
}
