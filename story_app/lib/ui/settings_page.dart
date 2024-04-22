import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/login_page.dart';

class SettingsPage extends StatefulWidget {
  static const String goRouteName = 'settings_page';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextStyle _textStyleSubTitle =
      const TextStyle(fontWeight: FontWeight.bold);

  AppLocalizations? _appLocalizations;

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildSafeAreaWithScrollView(
        child: _buildBodyContainer(context),
      ),
    );
  }

  Widget _buildSafeAreaWithScrollView({
    required Widget child,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.settings),
      backgroundColor: colorSchemeCustom.surfaceContainer,
      surfaceTintColor: colorSchemeCustom.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const Gap(8),
          _buildAccountSettings(),
          const Divider(height: 16),
          _buildThemeAndLanguage(),
          const Divider(height: 16),
          _buildOtherSettings(context),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    const paddingHorizontal = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.account,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Icon(Icons.person, size: 32),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_appLocalizations!.account),
                    Text(_appLocalizations!.freeOfCharge),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeAndLanguage() {
    const paddingHorizontal = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.themeAndLanguage,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Icon(Icons.settings_display, size: 32),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_appLocalizations!.theme),
                    Text(_appLocalizations!.light),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Icon(Icons.language, size: 32),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_appLocalizations!.language),
                    Text(_appLocalizations!.languageId),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSettings(BuildContext context) {
    const paddingHorizontal = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.other,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            final provider = context.read<PreferencesProvider>();
            provider.setAndFetchLoginStatus(false);
            provider.removeAndFetchToken();

            context.go('/${LoginPage.goRoutePath}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Icon(Icons.logout, size: 32),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_appLocalizations!.signOut),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    return _buildScaffold(context);
  }
}
