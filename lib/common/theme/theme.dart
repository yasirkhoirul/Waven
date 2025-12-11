import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006c46),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff00321f),
      secondary: Color(0xff5d5f5f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffffff),
      onSecondaryContainer: Color(0xff747676),
      tertiary: Color(0xff5152b8),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff191583),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      onSurfaceVariant: Color(0xff4c4546),
      outline: Color(0xff7e7576),
      outlineVariant: Color(0xffcfc4c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff002112),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff005234),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff08006c),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff38399e),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f27),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff007d52),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff343637),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6c6d6d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff26258d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6061c8),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff3b3436),
      outline: Color(0xff585152),
      outlineVariant: Color(0xff736b6c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff007d52),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00623f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6c6d6d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff535555),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6061c8),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4748ad),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c6c6),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffe8e8e8),
      surfaceContainerHigh: Color(0xffdddddd),
      surfaceContainerHighest: Color(0xffd1d1d1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00341f),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005436),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2a2c2d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff48494a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b1784),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3b3ba1),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff312b2c),
      outlineVariant: Color(0xff4f4749),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff005436),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b24),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff48494a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff313333),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3b3ba1),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff22218a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9b9),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1f1),
      surfaceContainer: Color(0xffe2e2e2),
      surfaceContainerHigh: Color(0xffd4d4d4),
      surfaceContainerHighest: Color(0xffc6c6c6),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff5adda0),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff003823),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff00321f),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffe2e2e2),
      onSecondaryContainer: Color(0xff636565),
      tertiary: Color(0xffc1c1ff),
      onTertiary: Color(0xff201e88),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff191583),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131313),
      onSurface: Color(0xffe2e2e2),
      onSurfaceVariant: Color(0xffcfc4c5),
      outline: Color(0xff988e90),
      outlineVariant: Color(0xff4c4546),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff006c46),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff002112),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff005234),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff08006c),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff38399e),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff72f4b5),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff002c1a),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffe2e2e2),
      onSecondaryContainer: Color(0xff464849),
      tertiary: Color(0xffdad9ff),
      onTertiary: Color(0xff120c7e),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe5dadb),
      outline: Color(0xffbaafb1),
      outlineVariant: Color(0xff988e8f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff005335),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff00150a),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff003f27),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff0f1112),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff343637),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff04004d),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff26258d),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff444444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1d1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff323232),
      surfaceContainerHighest: Color(0xff3e3e3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbbffd7),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff56d99d),
      onPrimaryContainer: Color(0xff000e06),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe2e2e2),
      onSecondaryContainer: Color(0xff282a2b),
      tertiary: Color(0xfff1eeff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbcbdff),
      onTertiaryContainer: Color(0xff02003c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff9edef),
      outlineVariant: Color(0xffcbc0c1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff005335),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff00150a),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff0f1112),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff04004d),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff505050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff303030),
      surfaceContainerHigh: Color(0xff3b3b3b),
      surfaceContainerHighest: Color(0xff474747),
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
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
