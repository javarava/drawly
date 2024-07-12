import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/main.dart';
import '/routes/canvas.dart';
import '/routes/mydrawings.dart';
import '/routes/me.dart';
import '/routes/welcome.dart';
import '/routes/addprofile.dart';
import '/routes/error.dart';

//Route transition animation class - Down to Up
CustomTransitionPage slideDownToUpTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required var key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 300),
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0, 0.75),
          end: const Offset(0, 0),
        ).chain(
          CurveTween(curve: Curves.easeIn),
        ),
      ),
      child: child,
    ),
  );
}

//Route transition animation class - Right to left
CustomTransitionPage slideRightToLeftTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required var key,
}) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 300),
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.75, 0),
          end: const Offset(0, 0),
        ).chain(
          CurveTween(curve: Curves.easeIn),
        ),
      ),
      child: child,
    ),
  );
}

//Route transition animation class - FadeIn Page Transition
CustomTransitionPage fadeTransitionWithKey<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required var key,
}) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 300),
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      child: child,
    ),
  );
}

// private navigators
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorCanvasKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellCanvas');
final shellNavigatorMyDrawingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellMyDrawings');
final shellNavigatorMeKey = GlobalKey<NavigatorState>(debugLabel: 'shellMe');

//Router class
final goRouter = GoRouter(
  initialLocation: '/',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: shellNavigatorCanvasKey,
          routes: [
            //Home
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => fadeTransitionWithKey(
                context: context,
                state: state,
                key: UniqueKey,
                child: const Canvas(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorMyDrawingsKey,
          routes: [
            //Meet
            GoRoute(
              path: '/my-drawings',
              pageBuilder: (context, state) => fadeTransitionWithKey(
                context: context,
                state: state,
                key: UniqueKey,
                child: const MyDrawings(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorMeKey,
          routes: [
            // Messages
            GoRoute(
              path: '/me',
              pageBuilder: (context, state) => fadeTransitionWithKey(
                context: context,
                state: state,
                key: UniqueKey,
                child: const Me(),
              ),
              /* routes: [
                GoRoute(
                  path: 'me/editprofile',
                  pageBuilder: (context, state) => slideRightToLeftTransition(
                    context: context,
                    state: state,
                    key: UniqueKey(),
                    child: const EditProfile(),
                  ),
                ),
              ], */
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) => slideRightToLeftTransition(
        context: context,
        state: state,
        key: UniqueKey(),
        child: const Welcome(),
      ),
      routes: [
        GoRoute(
          path: 'addprofile',
          pageBuilder: (context, state) => slideDownToUpTransition(
            context: context,
            state: state,
            key: UniqueKey(),
            child: const AddProfile(),
          ),
        ),
      ],
    ),
  ],

  errorPageBuilder: (context, state) => MaterialPage<void>(
    key: state.pageKey,
    child: ErrorRoute(state.error),
  ),

  // redirect to the login page if the user is not logged in
  redirect: (context, state) {
    //Get user from provider
    final loggedIn =
        Provider.of<UserProvider>(context, listen: false).loggedinUser;

    //Initialize anonymous user routes
    final welcome = state.fullPath == '/welcome';
    final addprofile = state.fullPath == '/welcome/addprofile';

    //Check if user is logged in and redirect accordingly
    if (loggedIn != null) {
      if (welcome || addprofile) {
        return '/';
      } else {
        return null;
      }
    } else {
      if (welcome || addprofile) {
        return null;
      } else {
        return '/welcome';
      }
    }
  },
);
