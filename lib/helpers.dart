import 'package:flutter/cupertino.dart';

List<List<String>> calculate_cities_widgets({
  required BuildContext context,
  required List<String> cities_list,
  required int max_columns,

}) {

  int widget_width = 0;
  int width = MediaQuery.of(context).size.width.floor();
  List<List<String>> cities = new List.generate(max_columns, (i) => []);

  int columns = 0;
  for (var i in cities_list) {
    // 8 is left padding of Padding
    widget_width += 8;
    // 16 * 2 is left and right padding of Container
    widget_width += 16 * 2;
    // 8.8 is measurements average pixel width of one letter
    widget_width += (i.length * 8.8).ceil();
    if (widget_width > width){
      if (columns == max_columns) break;
      columns++;
      widget_width = 0;
    }
    cities[columns].add(i);
  }
  // print(widget_width);
  // print(cities);
  // print(width);
  return cities;
}