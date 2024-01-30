import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff765a0b),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdf9a),
      onPrimaryContainer: Color(0xff251a00),
      secondary: Color(0xff6b5d3f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff4e0bb),
      onSecondaryContainer: Color(0xff241a04),
      tertiary: Color(0xff496548),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffcbebc6),
      onTertiaryContainer: Color(0xff062109),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff4d4639),
      outline: Color(0xff7e7667),
      outlineVariant: Color(0xffd0c5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inverseOnSurface: Color(0xfff9efe2),
      inversePrimary: Color(0xffe7c26c),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xffe7c26c),
      onPrimaryFixedVariant: Color(0xff5a4300),
      secondaryFixed: Color(0xfff4e0bb),
      onSecondaryFixed: Color(0xff241a04),
      secondaryFixedDim: Color(0xffd7c4a0),
      onSecondaryFixedVariant: Color(0xff52452a),
      tertiaryFixed: Color(0xffcbebc6),
      onTertiaryFixed: Color(0xff062109),
      tertiaryFixedDim: Color(0xffafcfab),
      onTertiaryFixedVariant: Color(0xff324d31),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff554000),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8f7023),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4e4126),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff827354),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2e492e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5f7c5d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff494235),
      outline: Color(0xff665e50),
      outlineVariant: Color(0xff827a6b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inverseOnSurface: Color(0xfff9efe2),
      inversePrimary: Color(0xffe7c26c),
      primaryFixed: Color(0xff8f7023),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff735808),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff827354),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff685a3d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5f7c5d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff476345),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff2d2000),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff554000),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2b2108),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4e4126),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0d2810),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff2e492e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff292318),
      outline: Color(0xff494235),
      outlineVariant: Color(0xff494235),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffeac0),
      primaryFixed: Color(0xff554000),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3a2a00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4e4126),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff362b12),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff2e492e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff183219),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe7c26c),
      surfaceTint: Color(0xffe7c26c),
      onPrimary: Color(0xff3f2e00),
      primaryContainer: Color(0xff5a4300),
      onPrimaryContainer: Color(0xffffdf9a),
      secondary: Color(0xffd7c4a0),
      onSecondary: Color(0xff3a2f15),
      secondaryContainer: Color(0xff52452a),
      onSecondaryContainer: Color(0xfff4e0bb),
      tertiary: Color(0xffafcfab),
      onTertiary: Color(0xff1c361d),
      tertiaryContainer: Color(0xff324d31),
      onTertiaryContainer: Color(0xffcbebc6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff17130b),
      onBackground: Color(0xffebe1d4),
      surface: Color(0xff17130b),
      onSurface: Color(0xffebe1d4),
      surfaceVariant: Color(0xff4d4639),
      onSurfaceVariant: Color(0xffd0c5b4),
      outline: Color(0xff999080),
      outlineVariant: Color(0xff4d4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inverseOnSurface: Color(0xff353027),
      inversePrimary: Color(0xff765a0b),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xffe7c26c),
      onPrimaryFixedVariant: Color(0xff5a4300),
      secondaryFixed: Color(0xfff4e0bb),
      onSecondaryFixed: Color(0xff241a04),
      secondaryFixedDim: Color(0xffd7c4a0),
      onSecondaryFixedVariant: Color(0xff52452a),
      tertiaryFixed: Color(0xffcbebc6),
      onTertiaryFixed: Color(0xff062109),
      tertiaryFixedDim: Color(0xffafcfab),
      onTertiaryFixedVariant: Color(0xff324d31),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecc670),
      surfaceTint: Color(0xffe7c26c),
      onPrimary: Color(0xff1f1500),
      primaryContainer: Color(0xffad8c3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdbc9a4),
      onSecondary: Color(0xff1e1501),
      secondaryContainer: Color(0xff9f8f6e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb3d3af),
      onTertiary: Color(0xff021b05),
      tertiaryContainer: Color(0xff7a9877),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff17130b),
      onBackground: Color(0xffebe1d4),
      surface: Color(0xff17130b),
      onSurface: Color(0xfffffaf6),
      surfaceVariant: Color(0xff4d4639),
      onSurfaceVariant: Color(0xffd4c9b8),
      outline: Color(0xffaba291),
      outlineVariant: Color(0xff8b8273),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inverseOnSurface: Color(0xff2e2921),
      inversePrimary: Color(0xff5c4400),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff181000),
      primaryFixedDim: Color(0xffe7c26c),
      onPrimaryFixedVariant: Color(0xff463300),
      secondaryFixed: Color(0xfff4e0bb),
      onSecondaryFixed: Color(0xff181000),
      secondaryFixedDim: Color(0xffd7c4a0),
      onSecondaryFixedVariant: Color(0xff40351b),
      tertiaryFixed: Color(0xffcbebc6),
      onTertiaryFixed: Color(0xff001603),
      tertiaryFixedDim: Color(0xffafcfab),
      onTertiaryFixedVariant: Color(0xff223c22),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf6),
      surfaceTint: Color(0xffe7c26c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffecc670),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf6),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffdbc9a4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff0ffeb),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb3d3af),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff17130b),
      onBackground: Color(0xffebe1d4),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4d4639),
      onSurfaceVariant: Color(0xfffffaf6),
      outline: Color(0xffd4c9b8),
      outlineVariant: Color(0xffd4c9b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff372800),
      primaryFixed: Color(0xffffe4ac),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffecc670),
      onPrimaryFixedVariant: Color(0xff1f1500),
      secondaryFixed: Color(0xfff8e5bf),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffdbc9a4),
      onSecondaryFixedVariant: Color(0xff1e1501),
      tertiaryFixed: Color(0xffcff0ca),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb3d3af),
      onTertiaryFixedVariant: Color(0xff021b05),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
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

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
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
