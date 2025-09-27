import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Base class for animated pages with key support
abstract class AnimatedPage extends CustomTransitionPage {
  const AnimatedPage({
    required super.child,
    super.key,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    required super.transitionsBuilder,
  }) : super(
         transitionDuration:
             transitionDuration ?? const Duration(milliseconds: 300),
         reverseTransitionDuration:
             reverseTransitionDuration ?? const Duration(milliseconds: 300),
       );
}

/// Fade transition page
class FadePage extends AnimatedPage {
  FadePage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(opacity: animation, child: child);
         },
       );
}

/// Slide from right to left transition page
class SlideRightToLeftPage extends AnimatedPage {
  SlideRightToLeftPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(1.0, 0.0);
           const end = Offset.zero;
           final tween = Tween(begin: begin, end: end);
           final offsetAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeInOut)),
           );

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

/// Slide from left to right transition page
class SlideLeftToRightPage extends AnimatedPage {
  SlideLeftToRightPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(-1.0, 0.0);
           const end = Offset.zero;
           final tween = Tween(begin: begin, end: end);
           final offsetAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeInOut)),
           );

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

/// Slide from bottom to top transition page
class SlideBottomToTopPage extends AnimatedPage {
  SlideBottomToTopPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(0.0, 1.0);
           const end = Offset.zero;
           final tween = Tween(begin: begin, end: end);
           final offsetAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeInOut)),
           );

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

/// Slide from top to bottom transition page
class SlideTopToBottomPage extends AnimatedPage {
  SlideTopToBottomPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(0.0, -1.0);
           const end = Offset.zero;
           final tween = Tween(begin: begin, end: end);
           final offsetAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeInOut)),
           );

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

/// Scale up transition page
class ScaleUpPage extends AnimatedPage {
  ScaleUpPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = 0.0;
           const end = 1.0;
           final tween = Tween(begin: begin, end: end);
           final scaleAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeOut)),
           );

           return ScaleTransition(scale: scaleAnimation, child: child);
         },
       );
}

/// Scale down transition page
class ScaleDownPage extends AnimatedPage {
  ScaleDownPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = 1.0;
           const end = 0.0;
           final tween = Tween(begin: begin, end: end);
           final scaleAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeIn)),
           );

           return ScaleTransition(scale: scaleAnimation, child: child);
         },
       );
}

/// Zoom in transition page
class ZoomInPage extends AnimatedPage {
  ZoomInPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = 0.0;
           const end = 1.0;
           final tween = Tween(begin: begin, end: end);
           final scaleAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeOut)),
           );

           return Transform.scale(
             scale: scaleAnimation.value,
             child: FadeTransition(
               opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
               child: child,
             ),
           );
         },
       );
}

/// Zoom out transition page
class ZoomOutPage extends AnimatedPage {
  ZoomOutPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = 1.0;
           const end = 0.0;
           final tween = Tween(begin: begin, end: end);
           final scaleAnimation = animation.drive(
             tween.chain(CurveTween(curve: Curves.easeIn)),
           );

           return Transform.scale(
             scale: scaleAnimation.value,
             child: FadeTransition(
               opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
               child: child,
             ),
           );
         },
       );
}

/// Flip horizontal transition page
class FlipHorizontalPage extends AnimatedPage {
  FlipHorizontalPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               const double turns = 0.5;
               return Transform(
                 alignment: Alignment.center,
                 transform: Matrix4.identity()
                   ..setEntry(3, 2, 0.001)
                   ..rotateY(animation.value * turns * 2.0 * 3.14159),
                 child: child,
               );
             },
             child: child,
           );
         },
       );
}

/// Flip vertical transition page
class FlipVerticalPage extends AnimatedPage {
  FlipVerticalPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               const double turns = 0.5;
               return Transform(
                 alignment: Alignment.center,
                 transform: Matrix4.identity()
                   ..setEntry(3, 2, 0.001)
                   ..rotateX(animation.value * turns * 2.0 * 3.14159),
                 child: child,
               );
             },
             child: child,
           );
         },
       );
}

/// Rotate transition page
class RotatePage extends AnimatedPage {
  RotatePage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return RotationTransition(
             turns: animation.drive(CurveTween(curve: Curves.easeInOut)),
             child: child,
           );
         },
       );
}

/// Bounce transition page
class BouncePage extends AnimatedPage {
  BouncePage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               final bounceValue = Curves.bounceOut.transform(animation.value);
               return Transform.scale(scale: bounceValue, child: child);
             },
             child: child,
           );
         },
       );
}

/// Elastic transition page
class ElasticPage extends AnimatedPage {
  ElasticPage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return AnimatedBuilder(
             animation: animation,
             builder: (context, child) {
               final elasticValue = Curves.elasticOut.transform(
                 animation.value,
               );
               return Transform.scale(scale: elasticValue, child: child);
             },
             child: child,
           );
         },
       );
}

/// Crossfade transition page
class CrossfadePage extends AnimatedPage {
  CrossfadePage({
    required super.child,
    super.key,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
             child: FadeTransition(
               opacity: secondaryAnimation.drive(
                 CurveTween(curve: Curves.easeInOut),
               ),
               child: child,
             ),
           );
         },
       );
}

/// Usage example with GoRouter:
/// 
/// ```dart
/// GoRoute(
///   path: '/home',
///   name: 'home',
///   pageBuilder: (context, state) {
///     return FadePage(
///       key: state.pageKey, // Pass the page key
///       child: HomePage(),
///       transitionDuration: Duration(milliseconds: 300),
///     );
///   },
/// ),
/// 
/// GoRoute(
///   path: '/profile',
///   name: 'profile',
///   pageBuilder: (context, state) {
///     return SlideRightToLeftPage(
///       key: state.pageKey, // Pass the page key
///       child: ProfilePage(),
///     );
///   },
/// ),
/// 
/// GoRoute(
///   path: '/settings',
///   name: 'settings',
///   pageBuilder: (context, state) {
///     return BouncePage(
///       key: state.pageKey, // Pass the page key
///       child: SettingsPage(),
///       transitionDuration: Duration(milliseconds: 500),
///     );
///   },
/// ),
/// ```
