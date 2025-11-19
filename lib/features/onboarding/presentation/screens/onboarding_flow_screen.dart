import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../../core/routes/app_routes.dart';
import 'onboarding_screen_1.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';
import 'onboarding_screen_4.dart';
import 'onboarding_screen_5.dart';
import 'onboarding_screen_6.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final GlobalKey<IntroductionScreenState> _introKey =
      GlobalKey<IntroductionScreenState>();

  void _goToNextPage() {
    _introKey.currentState?.next();
  }

  void _goToPreviousPage() {
    _introKey.currentState?.previous();
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: Colors.black,
      showDoneButton: false,
      showNextButton: false,
      showSkipButton: false,
      rawPages: [
        OnboardingScreen1(onNext: _goToNextPage),
        OnboardingScreen2(onNext: _goToNextPage),
        OnboardingScreen3(onNext: _goToNextPage, onBack: _goToPreviousPage),
        OnboardingScreen4(onNext: _goToNextPage, onBack: _goToPreviousPage),
        OnboardingScreen5(onNext: _goToNextPage, onBack: _goToPreviousPage),
        OnboardingScreen6(
          onFinish: _completeOnboarding,
          onBack: _goToPreviousPage,
        ),
      ],
      dotsDecorator: const DotsDecorator(
        color: Colors.transparent,
        activeColor: Colors.transparent,
        spacing: EdgeInsets.zero,
        size: Size(0, 0),
        activeSize: Size(0, 0),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
