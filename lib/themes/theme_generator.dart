import 'package:flutter/material.dart';

class ThemeGenerator {
  ThemeData getTheme(ThemeName name) {
    switch (name) {
      case ThemeName.searchAndRescue:
        return _searchAndRescue;
      case ThemeName.conservation:
        return _conservation;
      case ThemeName.coastguard:
      // TODO: Handle this case.
      case ThemeName.purpleHaze:
        return _purpleHaze;
    }
  }

  ThemeData get _searchAndRescue {
    var searchAndRescue = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: Colors.deepOrange),
        textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black87)),
        appBarTheme: const AppBarTheme(
            color: Colors.deepOrange,
            iconTheme: IconThemeData(color: Colors.black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.deepOrange,
            secondary: Colors.black));

    return searchAndRescue;
  }

  ThemeData get _conservation {
    var docLightGreen = Color(0xFF527f3b);
    var docDarkGreen = Color(0xFF184036);
    var docYellow = Color(0xFFFFC51C);
    var docBlue = Color(0xFF1C87C9);
    var dark = Color(0xFF384246);
    var light = Color(0xFFF5F4F2);

    var purpleHaze = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: light,
      primaryColorLight: light,
      highlightColor: docBlue,
      colorScheme: ColorScheme.fromSeed(
          seedColor: docLightGreen,
          primary: docLightGreen,
          primaryContainer: docDarkGreen,
          secondary: dark,
          tertiary: docBlue),
      drawerTheme: DrawerThemeData(
        backgroundColor: light,
      ),
      inputDecorationTheme: InputDecorationTheme(
          prefixIconColor: docLightGreen,
          filled: true,
          fillColor: light,
          suffixIconColor: docLightGreen),
      listTileTheme: ListTileThemeData(
        iconColor: docYellow,
        textColor: dark,
        selectedTileColor: docBlue,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: docDarkGreen, foregroundColor: docYellow),
      iconTheme: IconThemeData(color: docYellow),
      textTheme: TextTheme(
          displayLarge: TextStyle(color: dark),
          displayMedium: TextStyle(color: dark),
          displaySmall: TextStyle(color: dark),
          headlineLarge: TextStyle(color: dark),
          headlineMedium: TextStyle(color: dark),
          headlineSmall: TextStyle(color: dark),
          titleLarge: TextStyle(color: dark),
          titleMedium: TextStyle(color: dark),
          titleSmall: TextStyle(color: dark),
          bodyLarge: TextStyle(color: dark),
          bodyMedium: TextStyle(color: dark),
          bodySmall: TextStyle(color: dark),
          labelLarge: TextStyle(color: docYellow, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(color: docLightGreen),
          labelSmall: TextStyle(color: light)),
      appBarTheme: AppBarTheme(
          color: docDarkGreen, iconTheme: IconThemeData(color: light)),
    );

    return purpleHaze;
  }

  ThemeData get _purpleHaze {
    var purplePrimary = Colors.purpleAccent;
    var darkPurple = Color(0xFF2C0E37);
    var black = Colors.black;
    var palePurple = Color(0xFFFAE6FA);
    var accent = Color(0xFF76E5FC);

    var purpleHaze = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: darkPurple,
        primaryColorLight: palePurple,
        highlightColor: accent,
        drawerTheme: DrawerThemeData(
          backgroundColor: darkPurple,
        ),
        inputDecorationTheme: InputDecorationTheme(
            prefixIconColor: purplePrimary,
            filled: true,
            fillColor: darkPurple,
            suffixIconColor: purplePrimary),
        listTileTheme: ListTileThemeData(
            iconColor: purplePrimary,
            textColor: palePurple,
            selectedTileColor: accent),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: purplePrimary),
        textTheme: TextTheme(
            displayLarge: TextStyle(color: palePurple),
            displayMedium: TextStyle(color: palePurple),
            displaySmall: TextStyle(color: palePurple),
            headlineLarge: TextStyle(color: palePurple),
            headlineMedium: TextStyle(color: palePurple),
            headlineSmall: TextStyle(color: palePurple),
            titleLarge: TextStyle(color: palePurple),
            titleMedium: TextStyle(color: palePurple),
            titleSmall: TextStyle(color: palePurple),
            bodyLarge: TextStyle(color: palePurple),
            bodyMedium: TextStyle(color: palePurple),
            bodySmall: TextStyle(color: palePurple),
            labelLarge: TextStyle(color: palePurple),
            labelMedium: TextStyle(color: palePurple),
            labelSmall: TextStyle(color: palePurple)),
        appBarTheme: AppBarTheme(
            color: purplePrimary, iconTheme: IconThemeData(color: black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: purplePrimary,
            primary: purplePrimary,
            primaryContainer: black,
            secondary: darkPurple,
            tertiary: accent));

    return purpleHaze;
  }
}

enum ThemeName {
  searchAndRescue,
  conservation,
  coastguard,
  purpleHaze,
}
