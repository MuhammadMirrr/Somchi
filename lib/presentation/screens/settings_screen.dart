import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/ad_service.dart';
import '../../l10n/app_localizations.dart';
import '../providers/ad_free_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/segmented_control.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _appVersion = info.version);
    } catch (_) {
      // Sukut saqlaymiz — bo'sh string qoladi
    }
  }

  void _showDeveloperContactSheet() {
    HapticFeedback.selectionClick();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outlineVariant;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.space20,
              AppConstants.space12,
              AppConstants.space20,
              AppConstants.space20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppConstants.space16),
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  AppConstants.developerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.space4),
                Text(
                  l10n.settingsContact,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.space16),
                _ContactTile(
                  icon: Icons.send_rounded,
                  label: 'Telegram',
                  subtitle: '@mirqobilov_mm',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openUrl(AppConstants.developerTelegramUrl);
                  },
                ),
                const SizedBox(height: AppConstants.space8),
                _ContactTile(
                  icon: Icons.work_outline_rounded,
                  label: 'LinkedIn',
                  subtitle: 'muhammad-mirqobilov',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openUrl(AppConstants.developerLinkedInUrl);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmClearCache() async {
    HapticFeedback.selectionClick();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
          ),
          title: Text(l10n.settingsClearCacheQuestion),
          content: Text(l10n.settingsClearCacheBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    final provider = context.read<CurrencyProvider>();
    final messenger = ScaffoldMessenger.of(context);
    await provider.refreshRates();
    if (!mounted) return;

    final isError = provider.refreshStatus == RefreshStatus.error;
    messenger.showSnackBar(
      SnackBar(
        content: Text(isError
            ? l10n.settingsRefreshError
            : l10n.settingsCacheCleared),
        backgroundColor: isError ? AppColors.negative : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    HapticFeedback.selectionClick();
    final uri = Uri.parse(url);
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Chrome Custom Tabs (Android) / SFSafariViewController (iOS) — ilova
      // dizayniga integratsiyalashgan brauzer ko'rinishi
      final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!ok && mounted) {
        // Fallback — tashqi brauzer
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).settingsUrlOpenError),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outlineVariant;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.space16),

            // ── Title ──
            Text(
              l10n.settingsTitle,
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: AppConstants.space32),

            // ── Theme section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsAppearance),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SegmentedControl(
                  labels: [l10n.themeSystem, l10n.themeLight, l10n.themeDark],
                  selectedIndex: themeProvider.themeModeIndex,
                  onChanged: (index) {
                    HapticFeedback.selectionClick();
                    themeProvider.setThemeMode(index);
                  },
                );
              },
            ),

            const SizedBox(height: AppConstants.space24),

            // ── Language section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsLanguage),
            Consumer<LanguageProvider>(
              builder: (context, langProvider, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < _languageOptions.length; i++) ...[
                        _LanguageTile(
                          flag: _languageOptions[i].flag,
                          name: _languageOptions[i].name,
                          selected: langProvider.languageIndex == i,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            langProvider.setLanguage(i);
                          },
                        ),
                        if (i < _languageOptions.length - 1)
                          Divider(
                            height: 1,
                            indent: AppConstants.space16,
                            color: borderColor,
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppConstants.space24),

            // ── Data section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsData),
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(color: borderColor),
              ),
              child: Consumer<CurrencyProvider>(
                builder: (context, currencyProvider, _) {
                  final lastUpdated = currencyProvider.lastUpdated;
                  final formattedDate = lastUpdated != null
                      ? DateFormat(
                          'dd.MM.yyyy HH:mm',
                          Localizations.localeOf(context).toString(),
                        ).format(lastUpdated)
                      : l10n.settingsNeverUpdated;

                  return Column(
                    children: [
                      _buildInfoRow(
                        context,
                        label: l10n.settingsLastUpdate,
                        value: formattedDate,
                      ),
                      Divider(
                        height: 1,
                        indent: AppConstants.space16,
                        color: borderColor,
                      ),
                      _buildInfoRow(
                        context,
                        label: l10n.settingsClearCache,
                        value: '',
                        showChevron: true,
                        onTap: _confirmClearCache,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.space24),

            // ── About section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsAbout),
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    label: l10n.settingsVersion,
                    value: _appVersion.isEmpty ? '...' : _appVersion,
                  ),
                  Divider(
                    height: 1,
                    indent: AppConstants.space16,
                    color: borderColor,
                  ),
                  _buildInfoRow(
                    context,
                    label: l10n.settingsDataSource,
                    value: l10n.settingsDataSourceValue,
                    onTap: () => _openUrl(AppConstants.cbuWebsiteUrl),
                  ),
                  Divider(
                    height: 1,
                    indent: AppConstants.space16,
                    color: borderColor,
                  ),
                  _buildInfoRow(
                    context,
                    label: l10n.settingsDeveloper,
                    value: AppConstants.developerName,
                    showChevron: true,
                    onTap: _showDeveloperContactSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.space24),

            // ── Legal section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsLegal),
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    label: l10n.settingsTerms,
                    value: '',
                    showChevron: true,
                    onTap: () => _openUrl(AppConstants.termsOfUseUrl),
                  ),
                  Divider(
                    height: 1,
                    indent: AppConstants.space16,
                    color: borderColor,
                  ),
                  _buildInfoRow(
                    context,
                    label: l10n.settingsPrivacy,
                    value: '',
                    showChevron: true,
                    onTap: () => _openUrl(AppConstants.privacyPolicyUrl),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.space24),

            // ── Support section ──
            _buildSectionHeader(theme, textSecondary, l10n.settingsSupport),
            _SupportCard(isDark: isDark),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section header
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(
    ThemeData theme,
    Color textSecondary,
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.space12),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Info row — label + value (or chevron) used inside bordered containers
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    VoidCallback? onTap,
    bool showChevron = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space16,
        vertical: AppConstants.space14,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: showChevron
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: textSecondary,
                      size: AppConstants.iconSizeLarge,
                    ),
                  )
                : Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: content,
      );
    }

    return content;
  }
}

// =============================================================================
// Support card — rewarded video + ad-free countdown
// =============================================================================

class _SupportCard extends StatefulWidget {
  final bool isDark;

  const _SupportCard({required this.isDark});

  @override
  State<_SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<_SupportCard> {
  Timer? _countdownTimer;
  bool _isShowingAd = false;

  @override
  void initState() {
    super.initState();
    _startCountdownIfNeeded();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownIfNeeded() {
    _countdownTimer?.cancel();
    if (!mounted) return;
    final adFree = context.read<AdFreeProvider>();
    if (adFree.isAdFree) {
      _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {});
      });
    }
  }

  Future<void> _watchAd() async {
    if (_isShowingAd) return;
    setState(() => _isShowingAd = true);

    final adFreeProvider = context.read<AdFreeProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final success = await AdService.instance.showRewardedAd(
      onRewarded: () {
        adFreeProvider.recordWatch();
      },
    );

    if (mounted) {
      setState(() => _isShowingAd = false);

      final l10n = AppLocalizations.of(context);
      if (success) {
        _startCountdownIfNeeded();
        if (adFreeProvider.isAdFree) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.adFreeActivated),
              backgroundColor: AppColors.positive,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.adFreeRemaining(adFreeProvider.watchesRemaining),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        }
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.adLoadFailed),
            backgroundColor: AppColors.negative,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Consumer<AdFreeProvider>(
      builder: (context, adFree, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.space16),
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppColors.primarySurfaceDark
                : AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: adFree.isAdFree
              ? _buildAdFreeActive(theme, textSecondary, adFree)
              : _buildWatchPrompt(theme, textSecondary, adFree),
        );
      },
    );
  }

  /// Ad-free faol — countdown ko'rsatish
  Widget _buildAdFreeActive(
    ThemeData theme,
    Color textSecondary,
    AdFreeProvider adFree,
  ) {
    final l10n = AppLocalizations.of(context);
    final remaining = adFree.adFreeRemaining;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;

    return Column(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.positive,
          size: 32,
        ),
        const SizedBox(height: AppConstants.space12),
        Text(
          l10n.adFreeActive,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space8),
        Text(
          l10n.adFreeCountdown(hours, minutes),
          style: theme.textTheme.bodySmall?.copyWith(
            color: textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space12),
        Text(
          l10n.adFreeThanks,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Ko'rish mumkin — progress + tugma
  Widget _buildWatchPrompt(
    ThemeData theme,
    Color textSecondary,
    AdFreeProvider adFree,
  ) {
    final l10n = AppLocalizations.of(context);
    final used = adFree.watchesUsedToday;
    final max = AppConstants.maxDailyRewardedWatches;
    final remaining = adFree.watchesRemaining;
    final adReady = AdService.instance.isRewardedAdReady;

    return Column(
      children: [
        Icon(
          Icons.favorite_rounded,
          color: theme.colorScheme.primary,
          size: AppConstants.iconSizeXLarge,
        ),
        const SizedBox(height: AppConstants.space12),
        Text(
          l10n.adFreeSupportTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space4),
        Text(
          l10n.adFreeDescription(max),
          style: theme.textTheme.bodySmall?.copyWith(
            color: textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (used > 0) ...[
          const SizedBox(height: AppConstants.space16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            child: LinearProgressIndicator(
              value: used / max,
              minHeight: 6,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.15),
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.space8),
          Text(
            l10n.adFreeProgress(max, used),
            style: theme.textTheme.bodySmall?.copyWith(
              color: textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppConstants.space16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: (adReady && !_isShowingAd) ? _watchAd : null,
            icon: _isShowingAd
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.play_circle_outline_rounded, size: 20),
            label: Text(
              _isShowingAd
                  ? l10n.adButtonLoading
                  : adReady
                      ? l10n.adButtonWatch(remaining)
                      : l10n.adButtonAdLoading,
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.space12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Language selector — flag emoji + native name + checkmark
// =============================================================================

class _LanguageOption {
  final String flag;
  final String name;
  const _LanguageOption(this.flag, this.name);
}

// Til nomlari har doim o'z tilida ko'rsatiladi (standart UX pattern).
const _languageOptions = <_LanguageOption>[
  _LanguageOption('🇺🇿', "O'zbekcha"),
  _LanguageOption('🇺🇿', 'Ўзбекча'),
  _LanguageOption('🇷🇺', 'Русский'),
  _LanguageOption('🇬🇧', 'English'),
];

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16,
          vertical: AppConstants.space14,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: AppConstants.space12),
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                color: theme.colorScheme.primary,
                size: AppConstants.iconSizeLarge,
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Developer contact tile — bottom sheet ichida
// =============================================================================

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = theme.colorScheme.outlineVariant;
    final iconColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.space14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: AppConstants.iconSizeLarge),
            const SizedBox(width: AppConstants.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: textSecondary,
              size: AppConstants.iconSizeMedium,
            ),
          ],
        ),
      ),
    );
  }
}
