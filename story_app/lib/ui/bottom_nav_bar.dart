import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/settings_page.dart';

class BottomNavBar extends StatelessWidget {
  final Widget child;

  const BottomNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location == ListStoryPage.goRoutePath) return 0;
    if (location.contains(AddStoryPage.goRoutePath)) return 1;
    if (location.contains(SettingsPage.goRouteName)) return 2;

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        SettingsPage.isShowDialogTrue = false;
        context.go('/');
      case 1:
        SettingsPage.isShowDialogTrue = false;
        context.go("/${AddStoryPage.goRoutePath}");
      case 2:
        ListStoryPage.isShowDialogTrue = false;
        context.go("/${SettingsPage.goRouteName}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorSchemeCustom = context.read<MaterialThemeProvider>().currentSelected;
    final textTheme = Theme.of(context).textTheme;
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorSchemeCustom.outlineVariant,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: appLocalizations!.homeBarTitle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: appLocalizations.add,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: appLocalizations.settings,
            ),
          ],
          backgroundColor: colorSchemeCustom.surfaceContainer,
          selectedItemColor: colorSchemeCustom.secondary,
          unselectedItemColor: colorSchemeCustom.onSurfaceVariant,
          currentIndex: _calculateSelectedIndex(context),
          selectedFontSize: textTheme.labelMedium!.fontSize!,
          onTap: (index) => _onItemTapped(index, context),
        ),
      ),
    );
  }
}
