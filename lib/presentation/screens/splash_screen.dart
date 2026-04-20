import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:somchi/core/constants/app_constants.dart';
import 'package:somchi/core/theme/app_colors.dart';
import 'package:somchi/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _fadeOutController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    // Logo: scale up + fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // Text: fade in + slide up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Fade out everything
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Wait one frame so context is available for MediaQuery
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    final reduceMotion = MediaQuery.of(context).disableAnimations;

    if (reduceMotion) {
      // Skip all animations and show final state immediately
      _logoController.value = 1.0;
      _textController.value = 1.0;
      _fadeOutController.value = 0.0;
      // Short delay so the splash is briefly visible
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _fadeOutController.value = 1.0;
      widget.onComplete();
      return;
    }

    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    await _fadeOutController.forward();
    if (!mounted) return;

    widget.onComplete();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgImage =
        isDark ? 'assets/images/splash_dark.png' : 'assets/images/splash_light.png';

    // Status bar style
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return AnimatedBuilder(
      animation: _fadeOut,
      builder: (context, child) => Opacity(
        opacity: _fadeOut.value,
        child: child,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              bgImage,
              fit: BoxFit.cover,
            ),

            // Content overlay
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.space24),

                  // App name
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          Text(
                            AppConstants.appName,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: AppConstants.space8),
                          Text(
                            AppLocalizations.of(context).appTagline,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Bottom branding
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppConstants.space32),
                      child: Text(
                        AppLocalizations.of(context).splashSource,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: (isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight)
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
