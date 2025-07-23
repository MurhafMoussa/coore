import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadePage extends CustomTransitionPage {
  FadePage({
    required super.child,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) : super(
         transitionDuration:
             transitionDuration ?? const Duration(milliseconds: 300),
         reverseTransitionDuration:
             reverseTransitionDuration ?? const Duration(milliseconds: 300),
         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) {
               return FadeTransition(opacity: animation, child: child);
             },
       );
}
