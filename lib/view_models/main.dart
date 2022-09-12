import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/mml_app_localizations.dart';
import 'package:mml_app/components/filter_app_bar.dart';
import 'package:mml_app/services/router.dart';

/// View model for the main screen.
class MainViewModel extends ChangeNotifier {
  /// Route of the main screen.
  static const String route = '/main';

  // Appbar of the main view.
  static FilterAppBar? appBar;

  /// Current build context.
  late BuildContext _context;

  /// Locales of the app.
  late AppLocalizations locales;

  /// Index of the currently selected route.
  int _selectedIndex = 0;

  /// Router service used for navigation in the app.
  final RouterService _routerService = RouterService.getInstance();

  /// Items of the navigation bar.
  late final List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
      icon: const Icon(
        Icons.music_note_outlined,
      ),
      label: locales.records,
    ),
    BottomNavigationBarItem(
      icon: const Icon(
        Icons.playlist_play,
      ),
      label: locales.playlist,
    ),
    BottomNavigationBarItem(
      icon: const Icon(
        Icons.settings,
      ),
      label: locales.settings,
    ),
  ];

  /// Initializes the view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(_context)!;
    return true;
  }

  /// Pops the nested route.
  Future<bool> popNestedRoute(context) async {
    return !await _routerService.popNestedRoute();
  }

  /// Sets the actual screens [index] as selected.
  set selectedIndex(int index) {
    _selectedIndex = index;

    Future.microtask(() {
      notifyListeners();
    });
  }

  /// Returns index of the actual selected page.
  int get selectedIndex {
    return _selectedIndex;
  }

  /// Loads the selected page of the navigation.
  void loadPage(int index) async {
    var route = _routerService.getNestedRoutes().keys.elementAt(index);
    await _routerService.pushNestedRoute(route);
  }
}
