import 'package:flutter/material.dart';

Widget listview_builder(items){
  const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  const TextStyle timerStyle = TextStyle(fontSize: 18,);
  var listview = ListView.builder(
    itemCount: items.length,
    prototypeItem: ListTile(
      title: Text(items.first),
    ),
    itemBuilder: (context, index) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 70,
                  minHeight: 80,
                  maxWidth: double.infinity,
                  maxHeight: 390,
                ),
                child: Column(

                    children: [
                      Flexible(
                        flex: 13,
                        child: Image.asset(
                          'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Flexible(
                        flex: 8,

                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('TedX UA про волонтерство', style: optionStyle,),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 8, 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: Text('Постійна зайнятість', style: timerStyle,),
                                    ),
                                  ],
                                ),
                              ),
                              // Spacer(),
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('Вул. Валова, 27', style: timerStyle,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      );;
    },
  );
  return listview;
}
