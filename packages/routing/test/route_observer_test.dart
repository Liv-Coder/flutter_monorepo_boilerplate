import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routing/routing.dart';

void main() {
  test('appRouteObserver is a RouteObserver singleton', () {
    expect(appRouteObserver, isA<RouteObserver<ModalRoute<void>>>());
    final observer1 = appRouteObserver;
    final observer2 = appRouteObserver;
    expect(identical(observer1, observer2), isTrue);
  });
}
