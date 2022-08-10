import 'package:flutter/material.dart';
import 'package:mml_app/services/router.dart';
import 'package:mml_app/view_models/main.dart';
import 'package:mml_app/view_models/records/overview.dart';
import 'package:provider/provider.dart';

/// Main screen.
class MainScreen extends StatelessWidget {
  /// Initializes the instance.
  const MainScreen({Key? key}) : super(key: key);

  /// Builds the screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainViewModel>(
      create: (context) => MainViewModel(),
      builder: (context, _) {
        var vm = Provider.of<MainViewModel>(context, listen: false);
        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return WillPopScope(
              onWillPop: () => vm.popNestedRoute(context),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Consumer<MainViewModel>(
                    builder: (context, vm, _) {
                      return vm.getAppBar();
                    },
                  ),
                ),
                body: SafeArea(
                  child: Navigator(
                    initialRoute: RecordsViewModel.route,
                    observers: [_NestedRouteObserver(vm: vm)],
                    onGenerateRoute: (settings) {
                      return RouterService.getInstance().getNestedRoutes(
                        arguments: settings.arguments,
                      )[settings.name];
                    },
                  ),
                ),
                bottomNavigationBar: Consumer<MainViewModel>(
                  builder: (context, vm, _) {
                    return BottomNavigationBar(
                      backgroundColor: Theme.of(context).bottomAppBarColor,
                      showUnselectedLabels: false,
                      showSelectedLabels: false,
                      currentIndex: vm.selectedIndex,
                      onTap: (index) {
                        if (index == vm.selectedIndex) {
                          return;
                        }
                        vm.loadPage(index);
                      },
                      items: vm.navItems,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Route observer used to pop routes in the nested navigator.
class _NestedRouteObserver extends RouteObserver<PageRoute> {
  /// Main viewmodel used to update the selected index.
  MainViewModel vm;

  /// Intializes the observer.
  _NestedRouteObserver({required this.vm});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    vm.selectedIndex = getSelectedIndex(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    vm.selectedIndex = getSelectedIndex(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    vm.selectedIndex = getSelectedIndex(previousRoute);
  }

  /// Returns the selected index for the bottom navigation bar based on the
  /// passed [route] index in the nested route list.
  int getSelectedIndex(Route? route) {
    return RouterService.getInstance()
        .getNestedRoutes()
        .keys
        .toList()
        .indexOf(
          route?.settings.name ?? "",
        )
        .clamp(
          0,
          vm.navItems.length - 1,
        );
  }
}
