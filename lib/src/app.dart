import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/bloc/idea_cubit.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/screens/idea_submission_screen.dart';
import 'presentation/screens/idea_listing_screen.dart';
import 'presentation/screens/leaderboard_screen.dart';
import 'presentation/styles/gradients.dart';

class StartupIdeaApp extends StatelessWidget {
  const StartupIdeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => IdeaCubit()..loadIdeas()),
          ],
          child: MaterialApp(
            title: 'Startup Idea Evaluator',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            routes: {
              '/': (_) => const IdeaSubmissionScreen(),
              '/ideas': (_) => const IdeaListingScreen(),
              '/leaderboard': (_) => const LeaderboardScreen(),
            },
          ),
        );
      },
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: isDark ? AppGradients.darkOrange : AppGradients.primaryOrange,
      brightness: brightness,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: isDark ? AppGradients.darkBackground : AppGradients.lightBackground,
  );

  final textTheme = GoogleFonts.playfairDisplayTextTheme(base.textTheme);
  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
      elevation: 0,
      backgroundColor: isDark ? AppGradients.darkCardBackground : Colors.white,
      foregroundColor: isDark ? AppGradients.darkText : Colors.black87,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? AppGradients.darkText : Colors.black87,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isDark ? 4 : 2,
      margin: EdgeInsets.zero,
      color: isDark ? AppGradients.darkCardBackground : AppGradients.cardBackground,
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    dividerTheme: base.dividerTheme.copyWith(
      space: 24,
      color: isDark ? AppGradients.darkTextSecondary : Colors.grey[400],
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}


