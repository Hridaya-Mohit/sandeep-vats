import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';

final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.en);

final localizationsProvider = Provider<AppLocalizations>((ref) {
  return AppLocalizations(ref.watch(localeProvider));
});
