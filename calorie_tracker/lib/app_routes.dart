import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/add_food/add_food_screen.dart';
import 'screens/profile/profile_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final appState = context.read<AppState>();
    if (appState.isLoading) return null;

    final isProfileSet = appState.userProfile != null;
    final isOnboarding = state.uri.toString() == '/onboarding';

    if (!isProfileSet && !isOnboarding) return '/onboarding';
    if (isProfileSet && isOnboarding) return '/home';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-food',
      builder: (context, state) => const AddFoodScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);