import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/services/appservice.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../fragment/skill_card.dart';
import '../helpers.dart';
import '../models/events.dart';
import '../models/filter.dart';
import '../routes/routes.dart';
import '../fragment/skill_card.dart';


class FiltersCard extends StatefulWidget {
	const FiltersCard({super.key});

  @override
  State<FiltersCard> createState() => _FiltersCardState();
}

class _FiltersCardState extends State<FiltersCard> {
	late Future<Skills> futureSkills;
	late Future<Cities> futureCities;
	final String skills_query = '';
	final String cities_query = '';
	late AppService _app_service;
	final _form_key_city = GlobalKey<FormState>();
	final city_controller = TextEditingController();

	@override
  void dispose() {
		city_controller.dispose();
		super.dispose();
  }

	@override
	void initState() {
		_app_service = Provider.of<AppService>(context, listen: false);
		futureSkills = fetchSkills(skills_query);
		futureCities = fetchCities(cities_query);

		super.initState();
	}
	GlobalKey _keyRed = GlobalKey();
	@override
	Widget build(BuildContext context) {
		String error_text = 'Будь ласка, введіть назву локації';
		Widget form_city = Form(
			key: _form_key_city,
			child: Column(
				children: <Widget>[
					Padding(
						padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
						child: TextFormField(
							// decoration: InputDecoration(
							// 	labelText: 'UserName',
							// 	hintText: "YashodPerera",
							// ),
							controller: city_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Будь ласка, введіть назву локації';
								}
								else{
									Map<String, String> alias = {};
									alias = {'Кyiv' : 'Kyiv Kiev'};
									bool is_finded = false;
									for (var city in alias.keys){
										print(city);
										print(alias[city]);
										for (var alia in alias[city]!.split(' ')){
											if (alia.toLowerCase().startsWith(value.toLowerCase())){
												print('contain!! $city');
												is_finded = true;
												// _app_service.city_hint = [city];
											}
										}
									}
									if (!is_finded){
										_app_service.city_hint = [];
										return 'Локацію не знайдено :(';
									}
								}

								return null;
							},
							onChanged: (text) {
								setState(() {
									if (text.isEmpty){
										// _form_key_city.currentState!.validate();
									}else {
                    print(text);
                    Map<String, String> alias = {};
                    alias = {'Кyiv': 'Kyiv Kiev'};
                    bool is_finded = false;
                    for (var city in alias.keys) {
                      print(city);
                      print(alias[city]);
                      for (var alia in alias[city]!.split(' ')) {
                        if (alia.toLowerCase().startsWith(text.toLowerCase())) {
                          print('contain!! $city');
                          is_finded = true;
                          _app_service.city_hint = [city];
                        }
                      }
                    }
                    if (!is_finded) {
                      _app_service.city_hint = [];
                    }
                  }
                });
							},
							decoration: InputDecoration(
								border: OutlineInputBorder(
									borderRadius : BorderRadius.all(Radius.circular(16.0)),
								),
								hintText: 'Полтава',
								suffixIcon: IconButton(
									onPressed: city_controller.clear,
									icon: Icon(
										Icons.clear,
									),
								),
							),
						),
					),
				],
			),
		);

		return Scaffold(
			appBar: buildAppBar(
					() {
						Navigator.pop(context);
					},
					'Фільтри',
					'Зберегти'),

			body: Column(
			  children: [
					build_bold_left_text(
						'Локація',
						padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
					),
			    FutureBuilder<Cities>(
			    future: futureCities,
			    builder: (context, snapshot) {
			    	if (snapshot.hasData) {
							List<String> cities_list = [];
							Map<int, String> cities_alias = {};
							snapshot.data!.list.forEach((element) {cities_list.add(element.city); });
							snapshot.data!.list.forEach((element) {cities_alias[element.alias]; });
							cities_list.add('Інше');
							var cities_card_blueprint = calculate_cities_widgets(
									context: context,
									cities_list: cities_list,
									max_columns: 2,
							);
							var cr = <Widget>[];
							int index = 0;
							for (var row in cities_card_blueprint){
								var rc = <Widget>[];
								for (var city in row){
									rc.add(buildSkillCard(title: city, id:index));
									index++;
								}
								var r = Row(
									children: rc,
								);
								cr.add(r);
							}
							var c = Column(
								children: [
									...cr,
									_app_service.open_text_field_choose_other_city ? form_city : Container(),
									_app_service.open_text_field_choose_other_city && _app_service.city_hint.isNotEmpty
											? Column(children: [Text(_app_service.city_hint[0])],) : Container(),
								],
							);


							// var list_cards =
								return c;
								// 	Column(
								// 	children: [
								// 		Row(
								// 		  children: [
								// 				buildSkillCard('Kyiv'),
								// 				buildSkillCard('Odesa'),
								// 				buildSkillCard('Lviv'),
								// 				buildSkillCard('Dnipropetrovsk'),
								// 		  ],
								// 		),
								// 	],
								// );

							// return Text(snapshot.data!.count.toString());

			    	} else if (snapshot.hasError) {
			    		return Text('${snapshot.error}');
			    	}

			    	return const CircularProgressIndicator();
			    },
		),
			  ],
			),
			// body: SafeArea(
			// 	child: filters(
			// 				locations: locations, time_start: time_start, time_end: time_end,
			// 					skills: skills, employment: employment,)
			// ),
		// bottomNavigationBar: buildBottomNavigationBar(_onItemTapped, selected_index),

		);
	}
}