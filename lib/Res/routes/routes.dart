import 'package:get/get.dart';
import 'package:hostel_app/Res/routes/routes_name.dart';

import '../../User/View/create_issues_screen.dart';
import '../../User/View/history_screen.dart';
import '../../User/View/home_screen.dart';
import '../../User/View/hostel_fee.dart';
import '../../User/View/profile_screen.dart';
import '../../User/View/register_screen.dart';
import '../../User/View/room_availability.dart';
import '../../User/View/room_change_request.dart';

class AppRoutes {
  static appRoutes() => [
        // GetPage(
        //   name: RouteName.splashScreen,
        //   page: () => const SplashScreen(),
        //   transitionDuration: const Duration(milliseconds: 250),
        //   transition: Transition.leftToRightWithFade,
        // ),
        // GetPage(
        //   name: RouteName.loginScreen,
        //   page: () =>  const LoginScreen(),
        //   transitionDuration: const Duration(milliseconds:250 ),
        //   transition: Transition.leftToRightWithFade,
        // ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.roomChangeRequest,
          page: () => const RoomChangeRequest(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.hostelFee,
          page: () => const HostelFee(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.roomAvailability,
          page: () => const RoomAvailability(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.profileScreen,
          page: () => const ProfileScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.registerScreen,
          page: () => const RegisterScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.historyScreen,
          page: () => const HistoryScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.createIssueScreen,
          page: () => const CreateIssueScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
