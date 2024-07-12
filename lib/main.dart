import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';
import '/src/navigation.dart';

void main() async {
  // Turn off the # in the URLs on the web
  usePathUrlStrategy();

  //Handle erros
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  runApp(
    //user MultiProvider to add provider to widget tree
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      title: 'Drawly',
      theme: AppTheme.lightTheme(),
      //darkTheme: AppTheme.lightTheme(),
      //Remove Scroll Glow
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: RemoveScrollGlow(),
          child: child!,
        );
      },
    );
  }
}

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      //Check if screen size is less than 450px to display Scaffold as ScaffoldWithNavigationBar
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          navigationShell,
          navigationShell.currentIndex,
          goBranch,
        );
        //If screen is greater than 450px, display Scaffold as ScaffoldWithNavigationRail
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: goBranch,
        );
      }
    });
  }
}

//ScaffoldWithNavigationBar
class ScaffoldWithNavigationBar extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const ScaffoldWithNavigationBar(
      this.body, this.selectedIndex, this.onDestinationSelected,
      {super.key});

  @override
  State<ScaffoldWithNavigationBar> createState() =>
      _ScaffoldWithNavigationBarState();
}

class _ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  @override
  Widget build(BuildContext context) {
    Widget body = widget.body;
    int selectedIndex = widget.selectedIndex;
    Function(int) onDestinationSelecteds = widget.onDestinationSelected;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: body,
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 25.0,
        selectedColor: drawlyBlack.shade900,
        strokeColor: drawlyBlack.shade800,
        unSelectedColor: drawlyBlack.shade500,
        backgroundColor: drawlyBlack.shade100,
        bubbleCurve: Curves.elasticIn,
        currentIndex: selectedIndex,
        onTap: onDestinationSelecteds,
        items: [
          CustomNavigationBarItem(
            icon: Icon(MdiIcons.fromString('artboard')),
            selectedIcon: Icon(MdiIcons.fromString('artboard')),
            title: Text(
              "Canvas",
              style: AppTheme.buttonNavigationText(),
            ),
            selectedTitle: Text(
              "Canvas",
              style: AppTheme.buttonNavigationSelectedText(),
            ),
          ),
          CustomNavigationBarItem(
            icon: Icon(MdiIcons.fromString('file-multiple')),
            selectedIcon: Icon(MdiIcons.fromString('file-multiple')),
            title: Text(
              "My Drawings",
              style: AppTheme.buttonNavigationText(),
            ),
            selectedTitle: Text(
              "My Drawings",
              style: AppTheme.buttonNavigationSelectedText(),
            ),
          ),
          CustomNavigationBarItem(
            icon: Icon(MdiIcons.fromString('account')),
            selectedIcon: Icon(MdiIcons.fromString('account')),
            title: Text(
              "Me",
              style: AppTheme.buttonNavigationText(),
            ),
            selectedTitle: Text(
              "Me",
              style: AppTheme.buttonNavigationSelectedText(),
            ),
          ),
        ],
      ),
    );
  }
}

//ScaffoldWithNavigationRail
class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                label: const Text('Canvas'),
                icon: Icon(MdiIcons.fromString('artboard')),
              ),
              NavigationRailDestination(
                label: const Text('My Drawings'),
                icon: Icon(MdiIcons.fromString('file-multiple')),
              ),
              NavigationRailDestination(
                label: const Text('Me'),
                icon: Icon(MdiIcons.fromString('account')),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

//Remove Scroll Glow
class RemoveScrollGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
