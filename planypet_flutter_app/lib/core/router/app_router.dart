import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../presentation/chat/screens/chat_screen.dart';
import '../../presentation/community/screens/community_screen.dart';
import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/feeding/screens/feeding_log_screen.dart';
import '../../presentation/pets/screens/pet_detail_screen.dart';
import '../../presentation/pets/screens/pets_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/reminders/screens/reminders_screen.dart';
import 'main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.dashboardRoute,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: AppConstants.dashboardRoute,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppConstants.petsRoute,
            builder: (context, state) => const PetsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    PetDetailScreen(petId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.communityRoute,
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: AppConstants.profileRoute,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppConstants.feedingLogRoute,
        builder: (context, state) =>
            FeedingLogScreen(initialPetId: state.uri.queryParameters['petId']),
      ),
      GoRoute(
        path: AppConstants.remindersRoute,
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: AppConstants.chatRoute,
        builder: (context, state) => const ChatScreen(),
      ),
    ],
  );
});
