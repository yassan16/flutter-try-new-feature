import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/constant/const_route.dart';
import 'package:flutter_try_new_feature/page/feature_list/feature_list_page.dart';
import 'package:flutter_try_new_feature/main.dart';
import 'package:flutter_try_new_feature/page/feature_list/flutter_map_page.dart';
import 'package:flutter_try_new_feature/page/feature_list/get_currentLocation_page.dart';
import 'package:flutter_try_new_feature/page/feature_list/input_form_list_page.dart';
import 'package:flutter_try_new_feature/page/feature_list/selected_panel_images_page.dart';
import 'package:flutter_try_new_feature/page/pokemon_picturebook/pokemon_detail_description_page.dart';
import 'package:flutter_try_new_feature/page/pokemon_picturebook/pokemon_generation_list_page.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');


  final GoRouter appRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ConstRoute.featureListRoute,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          // Return the widget that implements the custom shell (in this case
          // using a BottomNavigationBar). The StatefulNavigationShell is passed
          // to be able access the state of the shell and to navigate to other
          // branches in a stateful way.
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the first tab of the
                // bottom navigation bar.
                // feature_list へのパス
                path: ConstRoute.featureListRoute,
                builder: (BuildContext context, GoRouterState state) =>
                    const FeatureListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: ConstRoute.selectImagePanelRoute,
                    builder: (BuildContext context, GoRouterState state) =>
                        const SelectedImagePanelPage(),
                  ),
                  GoRoute(
                    path: ConstRoute.inputFormListRoute,
                    builder: (BuildContext context, GoRouterState state) =>
                        const InputFormListPage(),
                  ),
                  GoRoute(
                    path: ConstRoute.useFlutterMapRoute,
                    builder: (BuildContext context, GoRouterState state) =>
                        const FlutterMapPage(),
                  ),
                  GoRoute(
                    path: ConstRoute.useGeolocatorRoute,
                    builder: (BuildContext context, GoRouterState state) =>
                        const GetCurrentLocationPage(),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the first tab of the
                // bottom navigation bar.
                path: '/a',
                builder: (BuildContext context, GoRouterState state) =>
                    const RootScreen(label: 'A', detailsPath: '/a/details'),
                routes: <RouteBase>[
                  // The details screen to display stacked on navigator of the
                  // first tab. This will cover screen A but not the application
                  // shell (bottom navigation bar).
                  GoRoute(
                    path: 'details',
                    builder: (BuildContext context, GoRouterState state) =>
                        const DetailsScreen(label: 'A'),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the second tab of the bottom navigation bar.
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the second tab of the
                // bottom navigation bar.
                path: '/b',
                builder: (BuildContext context, GoRouterState state) =>
                    const RootScreen(
                  label: 'B',
                  detailsPath: '/b/details/1',
                  secondDetailsPath: '/b/details/2',
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details/:param',
                    builder: (BuildContext context, GoRouterState state) =>
                        DetailsScreen(
                      label: 'B',
                      param: state.pathParameters['param'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the third tab of the bottom navigation bar.
          // ポケモン図鑑
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: ConstRoute.pokemonPictureBookRoute,
                builder: (BuildContext context, GoRouterState state) =>
                  const PokemonGenerationListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details',
                    builder: (BuildContext context, GoRouterState state) =>
                        PokemonDetailDescriptionPage(),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    ],
  );

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.checklist_rtl), label: 'Feature List'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section A'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section B'),
          BottomNavigationBarItem(icon: Icon(Icons.catching_pokemon), label: 'Section C'),
        ],
        // Itemが4つ以上の場合、ホワイトアウトするので対策
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
