import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/provider/localizations_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/widget/alert_dialog_option.dart';

class SettingsPage extends StatefulWidget {
  static const String goRouteName = 'settings_page';
  static bool isShowDialogTrue = true;

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextStyle? _textStyleSubTitle;
  TextStyle? _textStyleBody;

  AppLocalizations? _appLocalizations;
  MaterialScheme? _colorSchemeCustom;
  TextTheme? _textTheme;

  final List<String> _listThemeModeLabel = [];
  ThemeMode _themeMode = ThemeMode.system;

  late final List<Locale> _listLocaleSupported;
  Locale _locale = const Locale('en');

  final List<String> _listLocaleSupportedLabel = [];

  @override
  void initState() {
    SettingsPage.isShowDialogTrue = true;
    _listLocaleSupported = [
      LocalizationsProvider.localeSystem,
      ...AppLocalizations.supportedLocales,
    ];
    super.initState();
  }

  void _initTheme(BuildContext context) {
    _listThemeModeLabel.clear();
    _listThemeModeLabel.addAll([
      _appLocalizations!.system,
      _appLocalizations!.light,
      _appLocalizations!.dark,
    ]);

    final providerTheme = context.watch<MaterialThemeProvider>();
    final themeMode = providerTheme.themeMode;
    _themeMode = themeMode;
  }

  void _initLocale(BuildContext context) {
    _listLocaleSupportedLabel.clear();
    _listLocaleSupportedLabel.addAll([
      _appLocalizations!.system,
      StringData.langEnglish,
      StringData.langBahasaIndonesia,
    ]);

    final providerLocalizations = context.watch<LocalizationsProvider>();
    final locale = providerLocalizations.locale;
    print('settings, _initLocale, locale: $locale');
    _locale = locale;
  }

  void _initStyle(BuildContext context) {
    _textStyleSubTitle = _textTheme!.titleMedium?.copyWith(
      color: _colorSchemeCustom!.onSurface,
      fontWeight: FontWeight.bold,
    );
    _textStyleBody = _textTheme!.bodyMedium?.copyWith(
      color: _colorSchemeCustom!.onSurface,
    );
  }

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
        context.read<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(
        _appLocalizations!.settings,
        style: _textTheme!.titleLarge?.copyWith(
          color: colorSchemeCustom.onSurface,
        ),
      ),
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
    const paddingHorizontal = 16.0;

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const Gap(8),
          _buildAccountSettings(context, paddingHorizontal),
          const Divider(height: 16),
          _buildThemeAndLanguage(context, paddingHorizontal),
          const Divider(height: 16),
          _buildOtherSettings(context, paddingHorizontal),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, double paddingHorizontal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.account,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            String text = '';
            if (FlavorConfig.instance.flavorValues.isPaidVersion) {
              text = _appLocalizations!.accountTypeInfoPaid;
            } else {
              text = _appLocalizations!.accountTypeInfoFreeOfCharge;
            }

            SnackBar snackBar = SnackBar(
              content: Text(text),
              duration: const Duration(seconds: 1),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
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
                    Text(_appLocalizations!.account, style: _textStyleBody),
                    if (FlavorConfig.instance.flavorValues.isPaidVersion)
                      Text(_appLocalizations!.paid, style: _textStyleBody)
                    else
                      Text(
                        _appLocalizations!.freeOfCharge,
                        style: _textStyleBody,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeAndLanguage(
      BuildContext context, double paddingHorizontal) {
    String themePickName() {
      switch (_themeMode) {
        case ThemeMode.system:
          return _appLocalizations!.system;
        case ThemeMode.light:
          return _appLocalizations!.light;
        case ThemeMode.dark:
          return _appLocalizations!.dark;
      }
    }

    String langPickName() {
      switch (_locale.languageCode) {
        case 'id':
          return StringData.langBahasaIndonesia;
        case 'en':
          return StringData.langEnglish;
        case 'system':
          return _appLocalizations!.system;
        default:
          return StringData.langEnglish;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.themeAndLanguage,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialogOption<ThemeMode>(
                  titleAlertDialog: _appLocalizations!.pickTheme,
                  height: 150,
                  groupedValue: _themeMode,
                  listValue: ThemeMode.values,
                  listLabel: _listThemeModeLabel,
                  textCancel: _appLocalizations!.cancel,
                  onTruePressed: (BuildContext context, ThemeMode value) {
                    final providerTheme = context.read<MaterialThemeProvider>();
                    final providerPref = context.read<PreferencesProvider>();

                    providerPref.setAndFetchTheme(value);
                    providerTheme.setCurrentSelected(context, value);

                    context.pop();
                  },
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
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
                    Text(_appLocalizations!.theme, style:  _textStyleBody),
                    Text(themePickName(), style: _textStyleBody),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialogOption<Locale>(
                  titleAlertDialog: _appLocalizations!.pickLanguage,
                  height: 150,
                  groupedValue: _locale,
                  listValue: _listLocaleSupported,
                  listLabel: _listLocaleSupportedLabel,
                  textCancel: _appLocalizations!.cancel,
                  onTruePressed: (BuildContext context, Locale value) {
                    final providerLocalizations =
                        context.read<LocalizationsProvider>();
                    final providerPref = context.read<PreferencesProvider>();

                    providerPref.setAndFetchLangCode(value.languageCode);
                    providerLocalizations.locale = value;

                    context.pop();
                  },
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
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
                    Text(_appLocalizations!.language, style: _textStyleBody),
                    Text(langPickName(), style: _textStyleBody),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSettings(BuildContext context, double paddingHorizontal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text(
            _appLocalizations!.other,
            style: _textStyleSubTitle,
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            final provider = context.read<PreferencesProvider>();
            provider.removeAndFetchLoginStatus();
            provider.removeAndFetchToken();

            SettingsPage.isShowDialogTrue = false;

            context.go('/${LoginPage.goRoutePath}');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
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
                    Text(_appLocalizations!.signOut, style: _textStyleBody),
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
    _colorSchemeCustom = context.read<MaterialThemeProvider>().currentSelected;
    _textTheme = Theme.of(context).textTheme;

    _initTheme(context);
    _initLocale(context);
    _initStyle(context);

    return _buildScaffold(context);
  }
}
