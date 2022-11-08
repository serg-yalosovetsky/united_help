import 'package:flutter/material.dart';
import '../fragment/bottom_navbar.dart';

class card_detail extends StatelessWidget {
  const card_detail({super.key});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
  );
  static const TextStyle timerBoldStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 70,
                        minHeight: 80,
                        maxWidth: double.infinity,
                        maxHeight: 450,
                      ),
                      child: Image.asset(
                        'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 800,
                  child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Align(
						  alignment: Alignment.centerLeft,
						  child: Text(
                            'TedX UA про волонтерство',
                            style: optionStyle,
                          ),
                        ),
                      ),
                      // Spacer(),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 8, 12),
                        child: Row(
                          children: [
                            Icon(Icons.access_time),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                              child: Text(
                                'Постійна зайнятість',
                                style: timerStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Вул. Валова, 27',
                                style: timerStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Запрошуємо волонтерів до гуманітарного штабу Тернополя. Ми потребуємо допомогу в розвантаженні фур, сортуванні гуманітарної допомоги, пакуванні на фронт й видачі допомоги потребуючим людям.',
                            style: timerStyle,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Align(
							alignment: Alignment.centerLeft,
                            child: Text(
                              'Необхідні скіли',
                              style: timerBoldStyle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: 500,
                        // width: 500,
                        margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
								buildSkillCard("Microsoft Office"),
								buildSkillCard("Комунікативність"),
                              ],
                            ),
                            Row(
                              children: <Widget>[
								buildSkillCard("Пунктуальність"),
								buildSkillCard("Організованість"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),

    );
  }

  Padding buildSkillCard(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFF0F3FF),
            ),
            color: Color(0xFFF0F3FF),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        // padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: timerStyle,
        ),
      ),
    );
  }
}
