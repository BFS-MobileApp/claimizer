import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static EventBus _instance = EventBus();

  static EventBus getInstance() {
    _instance = _instance ?? EventBus(sync: true);
    return _instance;
  }
}
