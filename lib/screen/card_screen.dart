import 'package:flutter/material.dart';
import '../fragment/card_detail.dart';


class JobCard extends StatelessWidget {
	const JobCard({super.key});

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
				title: const Text(
					'Назад',
					style: back_style,
				),
				backgroundColor: Colors.white,
				foregroundColor: Colors.blue,
			),
			body: const SafeArea(
				child: card_detail(
					title: title, image: image, location: location, time: time,
					description: description, skills: skills,),
			),

		);
	}
}