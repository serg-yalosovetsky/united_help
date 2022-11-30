import 'package:flutter/material.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/card_list.dart';
import '../fragment/skill_card.dart';


class AccountScreen extends StatelessWidget {
	const AccountScreen({super.key});
	void _showDialog(BuildContext context) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text("Alert!!"),
					content: Text("You are awesome!"),
					actions: [
						MaterialButton(
							child: Text("OK"),
							onPressed: () {
								Navigator.of(context).pop();
							},
						),
					],
				);
			},
		);
	}
	@override
	Widget build(BuildContext context) {
		const TextStyle back_style = TextStyle(color: Colors.blue);
		const String title = 'Гуманітарний штаб м.Тернопіль сортування продуктових наборів';
		const String image = 'images/Best-TED-Talks-From-The-Curator-Himself-.jpg';
		const String location = 'Вул. Валова, 27';
		const String time = 'Постійна зайнятість';
		const String description = 'Запрошуємо волонтерів до гуманітарного штабу Тернополя. Ми потребуємо допомогу в розвантаженні фур, сортуванні гуманітарної допомоги, пакуванні на фронт й видачі допомоги потребуючим людям.';
		const List skills = [
			"Microsoft Office", "Комунікативність",
			"Пунктуальність", "Організованість"
		];
		return Scaffold(
			appBar: AppBar(
				title: Row(
					children: [
						Icon(Icons.arrow_back_ios, size: 23,),
						const Text(
							'Назад',
							style: back_style,
						),
						Expanded(
							child: Padding(
								padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
								child: const Text(
									'Акаунт',
									style: TextStyle(color: Colors.black),
									textAlign: TextAlign.center,
								),
							),
						),
						// Icon(Icons.arrow_back_ios, color: Colors.white),
						const Text(
							'Нfpi',
							style: TextStyle(color: Colors.white),
						),
					],
				),
				backgroundColor: Colors.white,
				foregroundColor: Colors.blue,
				actions: [
					PopupMenuButton<int>(
						icon: Icon(Icons.more_horiz_rounded),
						enableFeedback: true,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(10.0),
						),
						itemBuilder: (context) => [
							PopupMenuItem(
								value: 1,
								child: Text("Налаштування"),
							),
							PopupMenuItem(
								value: 2,
								child: Text("Допомога"),
							),
							PopupMenuItem(
								value: 3,
								child: Text("Вийти з акаунта"),
							),
						],
						offset: Offset(0, 60),
						color: Colors.white,
						// elevation: 2,
						onSelected: (value) {
							if (value == 1) {
								_showDialog(context);
							} else if (value == 2) {
								_showDialog(context);
							}
						},
					),

				],
			),
			body: const SafeArea(
				child: card_detail(
					title: title, image: image, location: location, time: time,
					description: description, skills: skills,),
			),
			bottomNavigationBar: buildBottomNavigationBar(),

		);
	}
}



class card_detail extends StatelessWidget {
	const card_detail({
		Key? key,
		required this.title,
		required this.image,
		required this.time,
		required this.location,
		required this.description,
		required this.skills,
	}) : super(key: key);
	final String title;
	final String image;
	final String time;
	final String location;
	final String description;
	final List skills;

	static const TextStyle optionStyle =
	TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
	static const TextStyle timerStyle = TextStyle(
		fontSize: 18,
	);
	static const TextStyle timerBoldStyle =
	TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

	Widget return_skills_card(List skills, [int skill_in_row = 2]) {
		List<Widget> columns = [];
		int i = 0;
		while (i <= skills.length/2.ceil()) {
			List<Widget> rows = [];
			if (i < skills.length) rows.add(buildSkillCard(skills[i]));
			if (i + 1 < skills.length) rows.add(buildSkillCard(skills[i+1]));
			Widget row_widget = Row(
				children: rows,
			);
			columns.add(row_widget);
			i = i +2;
		}
		return Column(children: columns);
	}


	@override
	Widget build(BuildContext context) {

		return SafeArea(
				child: SingleChildScrollView(
					child: Center(
					  child: Column(
					  	crossAxisAlignment: CrossAxisAlignment.center,
					  	mainAxisAlignment: MainAxisAlignment.start,
					  	children: [
					  		Padding(
					  		  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
					  		  child: CircleAvatar(
					  		  	backgroundImage: AssetImage(
					  		  		'images/img_3.png'
					  		  	),
									radius: 50.0,
					  		  ),
					  		),
								Padding(
									padding: const EdgeInsets.fromLTRB(73, 15, 73, 0),
									child: const Text(
										'Ліза Мельник',
										style: TextStyle(
												color: Colors.black,
												fontSize: 17,
												fontWeight: FontWeight.w600
										),
										textAlign: TextAlign.center,
									),
								),
								Padding(
									padding: const EdgeInsets.fromLTRB(73, 7, 73, 0),
									child: const Text(
										'Волонтерю заради того, щоб у цьому світі було більше добра і щастя!',
										style: TextStyle(
												color: Color(0xff748B9F),
												fontSize: 17,
												fontWeight: FontWeight.w400
										),
										textAlign: TextAlign.center,
									),
								),

								Container(
									margin: const EdgeInsets.fromLTRB(16, 30, 0, 0),
									child: Align(
										alignment: Alignment.centerLeft,
										child: Text(
											'Контакти',
											style: timerBoldStyle,
										),
									),
								),

								Container(
									margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
									child: Align(
										alignment: Alignment.centerLeft,
										child: Row(
										  children: [
												Padding(
												  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
												  child: Icon(
												  	Icons.phone_rounded,
												  	color: Color(0xff002241),
														size: 26,
													),
												),
										    Text(
										    	'+380638945400',
													style: TextStyle(
															color: Color(0xff002241),
															fontSize: 18,
															fontWeight: FontWeight.w400
													),
										    	// style: timerBoldStyle,
										    ),
										  ],
										),
									),
								),

								Container(
									margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
									child: Align(
										alignment: Alignment.centerLeft,
										child: Row(
											children: [
												Padding(
													padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
													child: Icon(
														Icons.telegram_rounded,
														color: Color(0xff29b6f6),
														size: 26,
													),
												),
												Text(
													'@liza_melnik',
													style: TextStyle(
															color: Color(0xff002241),
															fontSize: 18,
															fontWeight: FontWeight.w400
													),
													// style: timerBoldStyle,
												),
											],
										),
									),
								),


								Row(
								  children: [
								    Expanded(
								      child: Align(
												alignment: Alignment.center,
												child: Container(
															margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
															child: Text(
																'Актуальне',
																style: timerBoldStyle,
															),
														),
								      ),
								    ),

										Expanded(
										  child: Align(
												alignment: Alignment.center,
												child: Container(
															margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
															child: Text(
																'Історія',
																style: timerBoldStyle,
															),
												),
										  ),
										),
								  ],
								),

								Row(
									children: [
										Expanded(
											child: Padding(
												padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
												child: ActiveDivider(),
											),
										),

										Expanded(
											child: Padding(
												padding: const EdgeInsets.fromLTRB(0, 13, 15, 0),
												child: InactiveDivider(),
											),
										),
									],
								),
								card_list(),

							],
					  ),
					),
				),

		);
	}
}

class InactiveDivider extends StatelessWidget {
  const InactiveDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
    	thickness: 1,
    	color: Color(0xffADBDCC),
    );
  }
}


class ActiveDivider extends StatelessWidget {
	const ActiveDivider({
		Key? key,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return const Divider(
			thickness: 1,
			color: Color(0xff0071D8),
		);
	}
}