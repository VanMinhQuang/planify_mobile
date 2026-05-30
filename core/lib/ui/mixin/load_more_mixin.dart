import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin ListBaseMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  bool _hasCalledBottom = false;

  ScrollToHideController? get scrollToHideController => null;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = scrollController.position;

    if (position.userScrollDirection == ScrollDirection.reverse) {
      scrollToHideController?.hide();
    } else if (position.userScrollDirection == ScrollDirection.forward) {
      scrollToHideController?.show();
    }

    if (position.pixels >= position.maxScrollExtent && !_hasCalledBottom) {
      _hasCalledBottom = true;
      onReachBottom();
    } else if (position.pixels < position.maxScrollExtent) {
      // reset once the user scrolls up
      _hasCalledBottom = false;
    }
  }

  void onReachBottom();
}

extension ScrollControllerX on ScrollController {
  void scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (hasClients && offset > 0) {
      animateTo(0, duration: duration, curve: curve);
    }
  }

  void scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (hasClients) {
      animateTo(position.maxScrollExtent, duration: duration, curve: curve);
    }
  }

  void jumpToTop() {
    if (hasClients) jumpTo(0);
  }

  void jumpToBottom() {
    if (hasClients) jumpTo(position.maxScrollExtent);
  }

  void scrollToOffset(
    double offset, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (hasClients) {
      animateTo(offset, duration: duration, curve: curve);
    }
  }

  bool get isAtTop => hasClients && offset <= 0;
  bool get isAtBottom => hasClients && offset >= position.maxScrollExtent;
  bool get isScrollable => hasClients && position.maxScrollExtent > 0;
}
