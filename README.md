# The Startup Idea Evaluator – AI + Voting App

A polished Flutter mobile app where users submit startup ideas, receive an AI-like rating (mocked), vote on other ideas, and view a leaderboard. The app features a modern, animated UI, a professional Roman typeface, theme-aware gradients, and persistent dark mode.

## ✨ Highlights
- Beautiful, animated onboarding header and form
- Sliding, animated gradient on the “Submit & Get AI Rating” button
- Idea listing with staggered slide-in animations
- Leaderboard with medals for top ideas
- Proper light/dark mode with persisted preference
- Clean Architecture with BLoC (Cubit), DI via GetIt, and local persistence
- Google Fonts: Playfair Display (modern Roman serif)

## 📱 Screens
- Submit Idea: Hero gradient header + animated, validated form
- Ideas: Sortable list (by rating or votes) with upvote and expand/collapse
- Leaderboard: Top 5 ideas with medals and gradient cards

## 🚀 Quick Start
Requirements
- Flutter 3.22+ (Dart 3.8+)
- Xcode (iOS) / Android SDK (Android)

Install and run
```bash
flutter pub get
flutter run
```
Pick a device/simulator when prompted.

Build release
```bash
# Android (APK)
flutter build apk --release

# iOS (requires signing)
flutter build ios --release
```

## 🧭 Project Structure
```
lib/
  src/
    app.dart                        # Root MaterialApp, themes, routing
    domain/
      entities/idea.dart            # IdeaEntity
      repositories/idea_repository.dart
    data/
      datasources/idea_local_data_source.dart  # SharedPreferences persistence
      repositories/idea_repository_impl.dart    # Concrete repository
    presentation/
      bloc/
        idea_cubit.dart            # Add, load, vote, sort
        theme_cubit.dart           # Theme mode persistence
      screens/
        idea_submission_screen.dart
        idea_listing_screen.dart
        leaderboard_screen.dart
      styles/
        gradients.dart             # Light/Dark palettes + gradients
```

## 🧩 Architecture
- Layered, Clean-inspired organization (domain → data → presentation)
- BLoC (Cubit) for state management
- GetIt for dependency injection
- SharedPreferences for local storage (portable, no platform-specific setup)

### State Management
- `IdeaCubit` manages list of ideas, submission, voting, and sorting
- `ThemeCubit` persists theme mode (light/dark)

AI rating is mocked at submission time:
```startLine:31:endLine:41:lib/src/presentation/bloc/idea_cubit.dart
Future<void> submitIdea({required String name, required String tagline, required String description}) async {
  final rating = Random().nextInt(101); // 0..100
  final idea = IdeaEntity(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    name: name,
    tagline: tagline,
    description: description,
    rating: rating,
    votes: 0,
  );
  await _repo.addIdea(idea);
  await loadIdeas();
}
```

## 🎨 Theming & Typography
- Global theme built in `src/app.dart` with Playfair Display:
  - Light/dark `ColorScheme.fromSeed`
  - Theme-aware scaffold, app bar, cards, dividers
- Dark mode toggle in the submit screen app bar (sun/moon icon). Preference persists across launches
- Typeface: `Playfair Display` for a refined, modern-Roman look

## 🌈 Gradients & Colors
Defined in `src/presentation/styles/gradients.dart`:
- Light and Dark palettes (backgrounds, surfaces, text)
- Primary/Secondary/Success gradients for light mode
- Dark equivalents for dark mode
- Lighter accent shades (e.g., `lightOrange`, `lightTeal`) for highlights

Animated button gradient
- Left-to-right animated gradient on the submit button using a custom `SlidingGradientTransform`
- Adapts automatically to light/dark palettes

## 🕹️ Animations
- Welcome header: fade + slide + elastic scale
- Staggered feature chips
- Form card: fade + slide + elastic scale
- Form fields: staggered fade + slide-in from left
- Idea list items: staggered slide-in with fade
- Submit button: entrance scale + continuous sliding gradient

## 💾 Persistence
- `SharedPreferences` stores ideas and theme mode
- Repository pattern isolates data layer from presentation

## 🔧 Developer Guide
Run analyzer
```bash
flutter analyze
```

Run tests
```bash
flutter test
```

Common edits
- Change fonts: `GoogleFonts.playfairDisplayTextTheme` in `src/app.dart`
- Tweak gradients/palettes: `src/presentation/styles/gradients.dart`
- Adjust animations: relevant widgets in `src/presentation/screens/*`

## 🗺️ Roadmap / Ideas
- Real AI scoring via an API (e.g., OpenAI/Vertex) instead of random rating
- Share to clipboard/social from idea cards
- Badges and richer card metadata (e.g., tags)
- Advanced sorting/filters and search
- Cloud sync (Supabase/Firebase) for multi-device persistence

## 🧱 Tech Stack
- Flutter, Dart, Material 3
- BLoC (Cubit), GetIt, SharedPreferences
- Google Fonts (Playfair Display)
- oktoast for in-app toasts

## ⚠️ Notes
- Some lints are informational (e.g., `withOpacity` deprecation notices). Production hardening can replace remaining usages with `withValues()` as needed.
- iOS release builds require proper signing profiles.

---
If you need me to tailor the documentation for deployment, CI/CD, or a specific store submission flow, say the word and I’ll extend this README.
