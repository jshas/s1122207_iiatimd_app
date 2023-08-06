import '../../business_logic/timer/constants/timer_items.dart';

class TimerDuration {
  int minute = 60;
  int defaultDuration = 30 * 60;

  TimerDuration({required this.defaultDuration, required this.minute});

  int reminderDuration(TimerItem item) {
    switch (item) {
      case TimerItem.short:
        return (15 * minute);
      case TimerItem.medium:
        return (30 * minute);
      case TimerItem.long:
        return (45 * minute);
      default:
        return defaultDuration;
    }
  }
}
