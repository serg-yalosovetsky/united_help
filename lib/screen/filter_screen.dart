import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/providers/appservice.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
// import '../fragment/data_picker.dart';
import '../fragment/no_internet.dart';
import '../fragment/skill_card.dart';
import '../fragment/text_field_helper.dart';
import '../helpers.dart';
import '../models/events.dart';
import '../models/filter.dart';
import '../routes/routes.dart';
import '../fragment/skill_card.dart';
import 'package:intl/intl.dart';

import '../providers/filters.dart';


class FiltersCard extends StatefulWidget {
	const FiltersCard({super.key});

  @override
  State<FiltersCard> createState() => _FiltersCardState();
}


Widget build_employments_rows({
	required data,
	// required BuildContext context,
	required int width,
	required AppService app_service,
	required Function fun,
	}
		) {
	List<String> cities_list = [];
	data.forEach((element) {cities_list.add(element); });
	var cities_card_blueprint = calculate_cities_widgets(
		// context: context,
		width: width,
		cities_list: cities_list,
		max_columns: 1,
	);
	var cr = <Widget>[];
	int index = 0;
	for (var row in cities_card_blueprint){
		var rc = <Widget>[];
		for (var city in row){
			rc.add(buildEmploymentCard(title: city, id:index));
			index++;
		}
		var r = Row(
			children: rc,
		);
		cr.add(r);
	}
	var c = Column(
		children: cr,
	);


	return c;

}

class _FiltersCardState extends State<FiltersCard> {
	late Future<Skills> futureSkills;
	late Future<Cities> futureCities;
	final String skills_query = '';
	final String cities_query = '';
	late AppService _app_service;
	late Filters _filters;
	final _form_key_city = GlobalKey<FormState>();
	final _form_key_skills = GlobalKey<FormState>();
	final city_controller = TextEditingController();
	final skills_controller = TextEditingController();

	TextEditingController start_date_controller = TextEditingController();
	TextEditingController start_time_controller = TextEditingController();
	TextEditingController end_date_controller = TextEditingController();
	TextEditingController end_time_controller = TextEditingController();

	@override
  void dispose() {
		city_controller.dispose();
		skills_controller.dispose();
		start_date_controller.dispose();
		start_time_controller.dispose();
		end_date_controller.dispose();
		end_time_controller.dispose();
		super.dispose();
  }

	@override
	void initState() {
		start_date_controller.text = '';
		start_time_controller.text = '';
		end_date_controller.text = '';
		end_time_controller.text = '';
		start_date_controller.text = date_to_str(DateTime.now());
		start_time_controller.text = time_to_str(TimeOfDay.now());
		end_date_controller.text = date_to_str(DateTime.now());
		end_time_controller.text = time_to_str(TimeOfDay.now());

		_app_service = Provider.of<AppService>(context, listen: false);
		_filters = Provider.of<Filters>(context, listen: false);

		futureSkills = fetchSkills(skills_query, _app_service);
		futureCities = fetchCities(cities_query, _app_service);
		super.initState();
	}

	@override
	Widget build(BuildContext context) {

		Widget form_city = Form(
			key: _form_key_city,
			child: Column(
				children: <Widget>[
					Padding(
						padding: const EdgeInsets.fromLTRB(17, 28, 17, 0),
						child: TextFormField(
							controller: city_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Будь ласка, введіть назву локації';
								}
								else{
									Map<String, String> alias = _filters.city_aliases;
									bool is_finded = false;
									for (var city in alias.keys){
										for (var alia in alias[city]!.split(' ')){
											if (alia.toLowerCase().startsWith(value.toLowerCase())){
												is_finded = true;
											}
										}
									}
									if (!is_finded){
										_filters.city_hint = [];
										return 'Локацію не знайдено :(';
									}
								}

								return null;
							},
							onChanged: (text) {
								setState(() {
									if (text.isEmpty){
									}else {
                    print(text);
										Map<String, String> alias = _filters.city_aliases;

										bool is_finded = false;
										List<String> cities_hint = [];
                    for (var city in alias.keys) {
                      for (var alia in alias[city]!.split(' ')) {
                        if (alia.toLowerCase().startsWith(text.toLowerCase())) {
                          is_finded = true;
													cities_hint.add(city);
                        }
                      }
                    }
										_filters.city_hint = cities_hint;

										if (!is_finded) {
											_filters.city_hint = [];
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

		Widget form_skills = Form(
			key: _form_key_skills,
			child: Column(
				children: <Widget>[
					Padding(
						padding: const EdgeInsets.fromLTRB(17, 11, 17, 0),
						child: TextFormField(
							// decoration: InputDecoration(
							// 	labelText: 'UserName',
							// 	hintText: "YashodPerera",
							// ),
							controller: skills_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Будь ласка, введіть вміння';
								}
								else{
									List<String> skills = ['reading', 'writing допомога', 'restling', 'remembering'];
									bool is_finded = false;
									for (var skill in skills){
											if (skill.toLowerCase().startsWith(value.toLowerCase())){
												is_finded = true;
												// _app_service.city_hint = [city];
										}
									}
									if (!is_finded){
										_filters.skills_hint = [];
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
										List<String> skills = ['reading', 'writing допомога', 'restling', 'remembering'];

										bool is_finded = false;
										List<String> skills_hint = [];

										for (var skill in skills) {
												if (skill.toLowerCase().startsWith(text.toLowerCase())) {
													is_finded = true;
													skills_hint.add(skill);
											}
										}
										_filters.skills_hint = skills_hint;
										if (!is_finded) {
											_filters.skills_hint = [];
										}
									}
								});
							},
							decoration: InputDecoration(
								border: OutlineInputBorder(
									borderRadius : BorderRadius.all(Radius.circular(16.0)),
								),
								hintText: 'Погрузка',
								suffixIcon: IconButton(
									onPressed: skills_controller.clear,
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
					TextButton(
						onPressed: () {},
						child: Text(
							'Зберегти',
							style: TextStyle(
								color: Color(0xFF0071D8),
								fontSize: 18,
								fontFamily: 'SF Pro Text',
								fontWeight: FontWeight.w400,
							),
						),
					)
			),

			body: SingleChildScrollView(
			  child: Consumer<Filters>(
					builder: (context, cart, child) {
						return Column(
			      children: [
			    		build_bold_left_text(
			    			'Локація',
			    			padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
			    		),
			        FutureBuilder<Cities>(
			    			future: futureCities,
			    			builder: (context, snapshot) {
			    				if (snapshot.hasData) {
									_filters.set_city_aliases(snapshot.data!.list!);
			    					return
										Wrap(
												children: List<Widget>.generate(
														max(snapshot.data!.list.length, 5),
														(index) =>  index < 5 ? buildCityCard(
																					id: snapshot.data!.list[index].id,
																					title: snapshot.data!.list[index].city,
																					fun: (String helper) {
																						setState(() {
																							city_controller.text = helper;
																							_filters.city_hint = [];
																						});
																					},
																				) :
																				buildCityCard(
																					id: 6,
																					title: 'Інше',
																					fun: (String helper) {
																						setState(() {
																							city_controller.text = helper;
																							_filters.city_hint = [];
																						});
																					},
																				),
														),
										);


			    				} else if (snapshot.hasError) {
									return build_no_internet(error: snapshot.error.toString());
								}
			    				return const CircularProgressIndicator();
			    				},
			    			),


						(form_city != null) && _filters.open_text_field_choose_other_city ? form_city : Container(),
						_filters.open_text_field_choose_other_city && _filters.city_hint.isNotEmpty
								? build_helpers_text(_filters.city_hint, (String helper) {
							setState(() {
								city_controller.text = helper;
								_filters.city_hint = [];
							});
						}) : Container(),

			    		build_bold_left_text(
			    			'Зайнятість',
			    			padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
			    		),

						Padding(
						  padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
						  child: Align(
						  	alignment: Alignment.centerLeft,
						    child: Wrap(
						    	children: List<Widget>.generate(
						    		employments_text.values.length,
						    		(index) => buildEmploymentCard(
						    			id: index,
						    			title: employments_listmap[index] ?? '',
						    			fun: (String helper) {
						    					setState(() {
						    						city_controller.text = helper;
						    						_filters.city_hint = [];
						    					});
						    			},
						    		)
						    	),
						    ),
						  ),
						),


			    		build_bold_left_text(
			    			'Вміння',
			    			padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
			    		),

			    		form_skills,
							_filters.skills_hint.isNotEmpty
										? build_helpers_text(_filters.skills_hint, (String helper) {
												setState(() {
													skills_controller.clear;
												_filters.skills_hint = [];
												if (!_filters.skills.contains(helper))
														_filters.skills.add(helper);
												});
											})
									: Container(),
						_filters.skills.isNotEmpty ?
								Padding(
									padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
									child: Align(
										alignment: Alignment.centerLeft,
										child: Wrap(
											children: List<Widget>.generate(
													_filters.skills.length,
															(index) => buildSkillCard(
																	id: index,
																	title: _filters.skills[index],
																	fun: (String helper) {
																		setState(() {
																			_filters.skills.remove(helper);

																		});
																	},
													)
											),
										),
									),
								) : Container() ,


							build_bold_left_text(
							'Дата',
							padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
						),

						Row(
						  children: [
								build_left_text('Початок'),

								build_date_picker(context: context,
										controller: start_date_controller,
										app_service_link: _filters.data_start),

								build_time_picker(context: context,
										controller: start_time_controller,
										app_service_link: _filters.time_start),

						  ],
						),


						Row(
							children: [
								build_left_text('Кінець   '),

								build_date_picker(context: context,
										controller: end_date_controller,
										app_service_link: _filters.data_end),

								build_time_picker(context: context,
																	controller: end_time_controller,
																	app_service_link: _filters.time_end),

							],
						),


			    	],
			    );
					},
			  ),
			),

		);
	}

	Widget build_left_text(String text) {
	  return Padding(
			padding: const EdgeInsets.fromLTRB(17.0, 0, 0, 0),
			child: Text(text,
				style: TextStyle(
						fontSize: 17,
						fontWeight: FontWeight.w500
				),
			),
		);
	}

	Widget build_date_picker({
		required BuildContext context,
		required TextEditingController controller,
		required app_service_link,
		start_year,
		end_year,
	}) {
	  return Container(
			padding:const EdgeInsets.fromLTRB(14, 4.5, 0, 4.5,),
			// height:150,
			width: 145,
			child: TextField(
				controller: controller,
				decoration: InputDecoration(
					border: OutlineInputBorder(
						borderRadius : BorderRadius.all(Radius.circular(16.0)),
					),
				),

				readOnly: true,
				onTap: () async {
					DateTime? pickedDate = await showDatePicker(
							context: context,
							initialDate: DateTime.now(),
							firstDate: DateTime(start_year ?? 2000),
							lastDate: DateTime(end_year ?? 2101)
					);

					if(pickedDate != null ){
						String formattedDate = date_to_str(pickedDate);
						setState(() {
							controller.text = formattedDate;
							app_service_link = pickedDate;
						});
					}else{
						print("Date is not selected");
					}
				},
			)
	);
	}

	Widget build_time_picker({
				required BuildContext context,
				required TextEditingController controller,
				required app_service_link,
	})  {
	  return Container(
				padding:const EdgeInsets.fromLTRB(14, 4.5, 0, 4.5,),
				width: 130,
				child: TextField(
					controller: controller, //editing controller of this TextField
					// decoration: const InputDecoration(
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
					),
					readOnly: true,  // when true user cannot edit text
					onTap: () async {
						TimeOfDay? pickedTime = await showTimePicker(
							context: context,
							initialTime: TimeOfDay.now(), //get today's date
						);

						if(pickedTime != null ){
							String formattedTime = time_to_str(pickedTime);
							setState(() {
								controller.text = formattedTime;
								app_service_link = pickedTime;
							});
						}else{
							print("Time is not selected");
						}
					},
				)
		);
	}


}