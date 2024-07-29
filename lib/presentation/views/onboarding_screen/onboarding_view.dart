import 'package:flutter/material.dart' as onboarding_view;
import 'package:flutter/material.dart';
import 'layout/body.dart';

class OnboardingView extends onboarding_view.StatelessWidget {

  @override
  onboarding_view.Widget build(onboarding_view.BuildContext context) {
    return  const Scaffold(
      body: OnboardingViewBody(),
    );
  }
}
