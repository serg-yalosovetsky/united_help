// Эта функция превращает строчное время с сервера в человекочитаемый вид
// если нужно отобразить диапазон времени, тогда мы сперва сверяем, одинаковый
// ли год месяц и день у двух чисел
// если он одинаков, и год текущий, то мы печатаем строку вида "время0-время1 месяц.день"
// если он одинаков, и год не текущий, то мы печатаем строку вида "время0-время1 год.месяц.день"
// если он одинаков, и время одинаково, то мы печатаем строку вида "время месяц.день"
// если же дипазоны времени имеют разную дату, то мы печатаем строку вида "время0 месяц0.день0 - время1 месяц1.день1"
//
// если нужно отобразить только начало евента, и год текущий, то мы печатаем строку вида "время месяц.день"
// если нужно отобразить только начало евента, и год не текущий, то мы печатаем строку вида "время год.месяц.день"

import 'debug_print.dart';

String show_nice_time(String time_start, [String? time_end]){
  final now = DateTime.now();
  String nice_time = '';

  if (time_end != null){
    try {
      final event_time = DateTime.parse(time_start);
      final event_time_end = DateTime.parse(time_end);

      if (event_time.year == event_time_end.year &&
          event_time.month == event_time_end.month &&
          event_time.day == event_time_end.day ) {

        if (!(event_time.hour == event_time_end.hour &&
            event_time.minute == event_time_end.minute )) {
          nice_time += '${event_time.hour}:${event_time.minute}-';
        }

        nice_time += '${event_time_end.hour}:${event_time_end.minute} ';
        if (now.year != event_time.year){
          nice_time += '${event_time.year}.';
        }
        nice_time += '${event_time.month}.${event_time.day}';

      } else {

        nice_time += '${event_time.hour}:${event_time.minute} ';
        if (now.year != event_time.year || now.year != event_time_end.year ) {
          nice_time += '${event_time.year}.';
        }
        nice_time += '${event_time.month}.${event_time.day} - ';

        if (now.year != event_time.year || now.year != event_time_end.year ) {
          nice_time += '${event_time.year}.';
        }
        nice_time += '${event_time.month}.${event_time.day}';
      }
    } on FormatException {
      dPrint('incorrect datetime $time_start');
      nice_time = time_start;
    }
  } else  {
    try {
      final event_time = DateTime.parse(time_start);
      nice_time += '${event_time.hour}:${event_time.minute} ';

      if (now.year != event_time.year) {
        nice_time += '${event_time.year}.';
      }
      nice_time += '${event_time.month}.${event_time.day}';

    } on FormatException {
      dPrint('incorrect datetime $time_start');
      nice_time = time_start;
    }
  }
  return nice_time;
}
