// we_dont_pay_much/core/widgets/app_scaffold.dart

import 'package:flutter/material.dart';

import 'package:we_dont_pay_much/core/constants/app_sizes.dart';

class AppPageContainer extends StatelessWidget {
  const AppPageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 600
            ? 520.0
            : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
