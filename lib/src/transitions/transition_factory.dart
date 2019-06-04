import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/base_transition_page_route.dart';
import 'package:sailor/src/transitions/concrete_transition_component.dart';
import 'package:sailor/src/transitions/decorators/fade_in_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/slide_bottom_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/slide_left_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/slide_right_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/slide_top_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/zoom_in_transition_decorator.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class TransitionFactory {
  static PageRoute buildTransition({
    RouteSettings settings,
    WidgetBuilder builder,
    Duration duration,
    Curve curve,
    List<SailorTransition> transitions,
  }) {
    TransitionComponent transitionComponent = ConcreteTransitionComponent();

    transitions?.forEach((transition) {
      switch (transition) {
        case SailorTransition.slide_from_left:
          {
            transitionComponent = SlideLeftTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
        case SailorTransition.slide_from_bottom:
          {
            transitionComponent = SlideDownTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
        case SailorTransition.slide_from_top:
          {
            transitionComponent = SlideDownTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
        case SailorTransition.slide_from_right:
          {
            transitionComponent = SlideRightTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
        case SailorTransition.zoom_in:
          {
            transitionComponent = ZoomInTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
        case SailorTransition.fade_in:
          {
            transitionComponent = FadeInTransitionDecorator(
                transitionComponent: transitionComponent);
            break;
          }
      }
    });

    return BaseTransitionPageRoute(
      settings: settings,
      builder: builder,
      transitionComponent: transitionComponent,
      duration: duration,
      curve: curve,
      useDefaultPageTransition: transitions == null || transitions.isEmpty,
    );
  }
}
