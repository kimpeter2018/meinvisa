import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff715c0c),
      surfaceTint: Color(0xff715c0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfffee086),
      onPrimaryContainer: Color(0xff564500),
      secondary: Color(0xff49672e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcaeea6),
      onSecondaryContainer: Color(0xff324e18),
      tertiary: Color(0xff8c4a60),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e2),
      onTertiaryContainer: Color(0xff703348),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f0),
      onSurface: Color(0xff1e1b13),
      onSurfaceVariant: Color(0xff4c4639),
      outline: Color(0xff7d7667),
      outlineVariant: Color(0xffcec6b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inversePrimary: Color(0xffe1c46d),
      primaryFixed: Color(0xfffee086),
      onPrimaryFixed: Color(0xff231b00),
      primaryFixedDim: Color(0xffe1c46d),
      onPrimaryFixedVariant: Color(0xff564500),
      secondaryFixed: Color(0xffcaeea6),
      onSecondaryFixed: Color(0xff0d2000),
      secondaryFixedDim: Color(0xffaed18c),
      onSecondaryFixedVariant: Color(0xff324e18),
      tertiaryFixed: Color(0xffffd9e2),
      onTertiaryFixed: Color(0xff3a071d),
      tertiaryFixedDim: Color(0xffffb1c7),
      onTertiaryFixedVariant: Color(0xff703348),
      surfaceDim: Color(0xffe1d9cc),
      surfaceBright: Color(0xfffff8f0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf3e5),
      surfaceContainer: Color(0xfff5eddf),
      surfaceContainerHigh: Color(0xffefe7da),
      surfaceContainerHighest: Color(0xffe9e2d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff433500),
      surfaceTint: Color(0xff715c0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff816b1c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff223d08),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff57763b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5c2237),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9d586e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f0),
      onSurface: Color(0xff141109),
      onSurfaceVariant: Color(0xff3b3629),
      outline: Color(0xff585244),
      outlineVariant: Color(0xff736c5e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inversePrimary: Color(0xffe1c46d),
      primaryFixed: Color(0xff816b1c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff675301),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff57763b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff405d25),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9d586e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff804056),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcdc6b9),
      surfaceBright: Color(0xfffff8f0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf3e5),
      surfaceContainer: Color(0xffefe7da),
      surfaceContainerHigh: Color(0xffe4dcce),
      surfaceContainerHighest: Color(0xffd8d1c3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff372b00),
      surfaceTint: Color(0xff715c0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff594700),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff183300),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff34511a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4f182d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff73354a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f0),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff302c20),
      outlineVariant: Color(0xff4e493b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inversePrimary: Color(0xffe1c46d),
      primaryFixed: Color(0xff594700),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3f3100),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff34511a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1f3905),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff73354a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff571f34),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbfb8ab),
      surfaceBright: Color(0xfffff8f0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f0e2),
      surfaceContainer: Color(0xffe9e2d4),
      surfaceContainerHigh: Color(0xffdbd4c6),
      surfaceContainerHighest: Color(0xffcdc6b9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe1c46d),
      surfaceTint: Color(0xffe1c46d),
      onPrimary: Color(0xff3c2f00),
      primaryContainer: Color(0xff564500),
      onPrimaryContainer: Color(0xfffee086),
      secondary: Color(0xffaed18c),
      onSecondary: Color(0xff1c3703),
      secondaryContainer: Color(0xff324e18),
      onSecondaryContainer: Color(0xffcaeea6),
      tertiary: Color(0xffffb1c7),
      onTertiary: Color(0xff541d32),
      tertiaryContainer: Color(0xff703348),
      onTertiaryContainer: Color(0xffffd9e2),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff16130b),
      onSurface: Color(0xffe9e2d4),
      onSurfaceVariant: Color(0xffcec6b4),
      outline: Color(0xff979080),
      outlineVariant: Color(0xff4c4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e2d4),
      inversePrimary: Color(0xff715c0c),
      primaryFixed: Color(0xfffee086),
      onPrimaryFixed: Color(0xff231b00),
      primaryFixedDim: Color(0xffe1c46d),
      onPrimaryFixedVariant: Color(0xff564500),
      secondaryFixed: Color(0xffcaeea6),
      onSecondaryFixed: Color(0xff0d2000),
      secondaryFixedDim: Color(0xffaed18c),
      onSecondaryFixedVariant: Color(0xff324e18),
      tertiaryFixed: Color(0xffffd9e2),
      onTertiaryFixed: Color(0xff3a071d),
      tertiaryFixedDim: Color(0xffffb1c7),
      onTertiaryFixedVariant: Color(0xff703348),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff3d392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1e1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2d2a21),
      surfaceContainerHighest: Color(0xff38342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff8da80),
      surfaceTint: Color(0xffe1c46d),
      onPrimary: Color(0xff2f2400),
      primaryContainer: Color(0xffa88f3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc4e7a0),
      onSecondary: Color(0xff142b00),
      secondaryContainer: Color(0xff7a9a5b),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd0dc),
      onTertiary: Color(0xff471227),
      tertiaryContainer: Color(0xffc67b92),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff16130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe5dbc9),
      outline: Color(0xffb9b1a0),
      outlineVariant: Color(0xff979080),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e2d4),
      inversePrimary: Color(0xff584600),
      primaryFixed: Color(0xfffee086),
      onPrimaryFixed: Color(0xff171000),
      primaryFixedDim: Color(0xffe1c46d),
      onPrimaryFixedVariant: Color(0xff433500),
      secondaryFixed: Color(0xffcaeea6),
      onSecondaryFixed: Color(0xff071500),
      secondaryFixedDim: Color(0xffaed18c),
      onSecondaryFixedVariant: Color(0xff223d08),
      tertiaryFixed: Color(0xffffd9e2),
      onTertiaryFixed: Color(0xff2b0012),
      tertiaryFixedDim: Color(0xffffb1c7),
      onTertiaryFixedVariant: Color(0xff5c2237),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff48443a),
      surfaceContainerLowest: Color(0xff090703),
      surfaceContainerLow: Color(0xff201d15),
      surfaceContainer: Color(0xff2b281f),
      surfaceContainerHigh: Color(0xff363229),
      surfaceContainerHighest: Color(0xff413d34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffefc6),
      surfaceTint: Color(0xffe1c46d),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffddc069),
      onPrimaryContainer: Color(0xff100b00),
      secondary: Color(0xffd7fbb3),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffabcd89),
      onSecondaryContainer: Color(0xff040e00),
      tertiary: Color(0xffffebef),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfffeabc4),
      onTertiaryContainer: Color(0xff20000c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff16130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff9efdc),
      outlineVariant: Color(0xffcac2b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e2d4),
      inversePrimary: Color(0xff584600),
      primaryFixed: Color(0xfffee086),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe1c46d),
      onPrimaryFixedVariant: Color(0xff171000),
      secondaryFixed: Color(0xffcaeea6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffaed18c),
      onSecondaryFixedVariant: Color(0xff071500),
      tertiaryFixed: Color(0xffffd9e2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb1c7),
      onTertiaryFixedVariant: Color(0xff2b0012),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff545045),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff231f17),
      surfaceContainer: Color(0xff343027),
      surfaceContainerHigh: Color(0xff3f3b32),
      surfaceContainerHighest: Color(0xff4b463c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
