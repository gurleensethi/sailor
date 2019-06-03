import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/base_transition_page_route.dart';
import 'package:sailor/src/transitions/concrete_transition_component.dart';
import 'package:sailor/src/transitions/decorators/slide_top_transition_decorator.dart';
import 'package:sailor/src/transitions/decorators/zoom_in_transition_decorator.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class TransitionFactory {
  static PageRoute buildTransition({
    RouteSettings settings,
    WidgetBuilder builder,
  }) {
    TransitionComponent transitionComponent = ConcreteTransitionComponent();

    transitionComponent = ZoomInTransitionDecorator(
      transitionComponent: transitionComponent,
    );

    transitionComponent = SlideTopTransitionDecorator(
      transitionComponent: transitionComponent,
    );
    return BaseTransitionPageRoute(
      settings: settings,
      builder: builder,
      transitionComponent: transitionComponent,
    );
  }
}
