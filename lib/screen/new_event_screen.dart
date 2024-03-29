import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/providers/appservice.dart';
import '../fragment/bottom_navbar.dart';
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
import 'dart:io';

import '../providers/filters.dart';
import '../services/debug_print.dart';
import 'card_screen.dart';


bool isNumeric(String s) {
	if (s == null) {
		return false;
	}
	return double.tryParse(s) != null;
}

var form_padding = const EdgeInsets.fromLTRB(16, 13, 16, 0);
var header_padding = const EdgeInsets.fromLTRB(0, 0, 8, 0);



Widget build_skills_columns({
	required data,
	// required BuildContext context,
	required int width,
	required AppService app_service,
	required Function fun,
}) {
	List<String> skills_list = [];
	data.forEach((element) {skills_list.add(element); });
	var skills_card_bluedPrint = calculate_cities_widgets(
		// context: context,
		width: width,
		cities_list: skills_list,
		max_columns: 2,
	);
	var cr = <Widget>[];
	int index = 0;
	for (var row in skills_card_bluedPrint){
		var rc = <Widget>[];
		for (var city in row){
			rc.add(buildSkillCard2(title: city, id:index, app_service: app_service, fun: fun,));
			index++;
		}
		var r = Row(
			children: rc,
		);
		cr.add(r);
	}

	return Column(
		children: [
			...cr,
		],
	);

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
	var cities_card_bluedPrint = calculate_cities_widgets(
		// context: context,
		width: width,
		cities_list: cities_list,
		max_columns: 1,
	);
	var cr = <Widget>[];
	int index = 0;
	for (var row in cities_card_bluedPrint){
		var rc = <Widget>[];
		for (var city in row){
			rc.add(buildEmploymentCard(title: city, ));
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



class NewEventScreen extends StatefulWidget {
	final String event_for_or_edit;
	const NewEventScreen({
		super.key,
		required this.event_for_or_edit,
	});

  @override
  State<NewEventScreen> createState() => NewEventScreenState();
}

class NewEventScreenState extends State<NewEventScreen> {

	final int image_index = 0;
	final int name_index = 1;
	final int bio_index = 2;
	final int location_index = 3;
	final int recuired_people_index = 4;
	late List<bool> button_states;

	late Future<Skills> futureSkills;
	late Roles event_for;
	late Future<Cities> futureCities;
	final String skills_query = '';
	final String cities_query = '';
	late AppService _app_service;
	late Filters filters;
	final _form_key_name = GlobalKey<FormState>();
	final _form_key_bio = GlobalKey<FormState>();
	final _form_key_location = GlobalKey<FormState>();
	final _form_key_city = GlobalKey<FormState>();
	final _form_key_skills = GlobalKey<FormState>();
	final _form_key_members = GlobalKey<FormState>();
	final _form_key_cancel_event = GlobalKey<FormState>();
	final name_controller = TextEditingController();
	final bio_controller = TextEditingController();
	final location_controller = TextEditingController();
	final city_controller = TextEditingController();
	final skills_controller = TextEditingController();
	final members_controller = TextEditingController();
	final cancel_event_controller = TextEditingController();
	Map skill_map = {};
	TextEditingController start_date_controller = TextEditingController();
	TextEditingController start_time_controller = TextEditingController();
	TextEditingController end_date_controller = TextEditingController();
	TextEditingController end_time_controller = TextEditingController();
	late bool one_time_counter;

	@override
  void dispose() {
		city_controller.dispose();
		location_controller.dispose();
		name_controller.dispose();
		bio_controller.dispose();
		members_controller.dispose();
		skills_controller.dispose();
		start_date_controller.dispose();
		start_time_controller.dispose();
		end_date_controller.dispose();
		end_time_controller.dispose();
		cancel_event_controller.dispose();
		super.dispose();
  }

	@override
	void initState() {
		one_time_counter = false;
		_app_service = Provider.of<AppService>(context, listen: false);
		filters = Provider.of<Filters>(context, listen: false);
		start_date_controller.text = date_to_str(DateTime.now());
		start_time_controller.text = time_to_str(TimeOfDay.now());
		end_date_controller.text = date_to_str(DateTime.now());
		end_time_controller.text = time_to_str(TimeOfDay.now());
		filters.date_start = DateTime.now();
		filters.date_end = DateTime.now();
		filters.time_start = TimeOfDay.now();
		filters.time_end = TimeOfDay.now();

		futureSkills = fetchSkills(skills_query, _app_service);
		futureCities = fetchCities(cities_query, _app_service);
		super.initState();
	}
	XFile? image = null;

	bool is_ready_to_submit() {
		return button_states.every((element) => element == true) &&
				(filters.city >- 1) && (filters.employment != null);
	}

	submit() async {
		bool is_edit_event = (isNumeric(widget.event_for_or_edit) &&
				int.tryParse(widget.event_for_or_edit)! >= 0);
		Event event = Event(

				id: is_edit_event ? int.tryParse(widget.event_for_or_edit)! : 0,
				name: name_controller.text,
				active: filters.event_active ?? true,
				description: bio_controller.text,
				reg_date: '',
				start_time: DateTime(
					filters.date_start?.year ?? 0,
					filters.date_start?.month ?? 0,
					filters.date_start?.day ?? 0,
					filters.time_start?.hour ?? 0,
					filters.time_start?.minute ?? 0,
				).toString(),
				end_time: DateTime(
					filters.date_end?.year ?? 0,
					filters.date_end?.month ?? 0,
					filters.date_end?.day ?? 0,
					filters.time_end?.hour ?? 0,
					filters.time_end?.minute ?? 0,
				).toString(),
				image: image?.path ?? '',
				city: filters.city,
				location: location_controller.text,
				employment: employments_to_int(filters.employment) ?? 0,
				owner: 0,
				to: roles_2_int(event_for),
				skills: List.generate(
					filters.skills_list.length,
						(index) => skill_map[filters.skills_list[index]],
				),
				required_members: int.parse(members_controller.text),
				subscribed_members: 0,
		);
		Map<String, dynamic> event_dict = event.to_dict();
		if (filters.event_active == null) {
		  event_dict.remove('active');
		}
		var res = await postEvents(event_dict, _app_service);
		context.go(APP_PAGE.my_events.to_path);
		// return res['success'] as bool;
	}

	void _showCancelDialog(BuildContext context, Event event) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return  AlertDialog(
					title: const Text("Alert!!"),
					content: Form(
						key: _form_key_cancel_event,
						child: TextFormField(
							controller: cancel_event_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'cancel event message cannot be null or empty';
								}
								return null;
							},
							decoration: InputDecoration(
								border: OutlineInputBorder(
									borderRadius : BorderRadius.all(Radius.circular(16.0)),
								),
								hintText: 'Напишіть cancel event message',
								suffixIcon: IconButton(
									onPressed: cancel_event_controller.clear,
									icon: Icon(
										Icons.clear,
									),
								),
							),
						),
					),
					actions: [
						MaterialButton(
							child: const Text("Cancel event"),
							onPressed:
								cancel_event_controller.text.isNotEmpty ?
										() async {
									filters.event_active = false;
									var res = await activate_deactivate_event(
											event?.id ?? 0,
											false,
											_app_service,
											cancel_message: cancel_event_controller.text);
									Navigator.of(context).pop();
								} : null,
						),

						MaterialButton(
							child: const Text("Back"),
							onPressed: () async {
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
		bool is_edit_event = (isNumeric(widget.event_for_or_edit) &&
														int.tryParse(widget.event_for_or_edit)! >= 0);
		if (!one_time_counter) {
			setState(() {
				button_states = List<bool>.generate(5,
								(index) => is_edit_event ? true : false
				);
				filters.city = 0;
				filters.employment = null;
			});

		}
		if (widget.event_for_or_edit == Roles.refugee.toString()) {
				event_for = Roles.refugee;
		} else {
			event_for = Roles.volunteer;
		}

		Widget form_city = Form(
			key: _form_key_city,
			child: Padding(
						padding: form_padding,
						child: TextFormField(
							controller: city_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Будь ласка, введіть назву локації';
								}
								else{
									Map<String, String> alias = filters.city_aliases;
									bool is_finded = false;
									for (var city in alias.keys){
											for (var alia in alias[city]!.split(' ')){
												if (alia.toLowerCase().startsWith(value.toLowerCase())){
													is_finded = true;
													// _app_service.city_hint = [city];
												}
											}
									}
									if (!is_finded){
										filters.city_hint = [];
										return 'Локацію не знайдено :(';
									}
								}

								return null;
							},
							onChanged: (text) {
								setState(() {
									if (text.isEmpty){
											// _form_key_city.currentState!.validate();
									} else {
                    dPrint(text);
										Map<String, String> alias = filters.city_aliases;

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
										filters.city_hint = cities_hint;

										if (!is_finded) {
											filters.city_hint = [];
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
		);

		Widget form_skills (Skills skills) {
			return Form(
				key: _form_key_skills,
				child: Padding(
					padding: form_padding,
					child: TextFormField(
						controller: skills_controller,
						onChanged: (text) {
							setState(() {
								if (text.isEmpty) {
								} else {
									bool is_finded = false;
									List<String> skills_hint = [];
									for (var skill in skills.list) {
										if (skill.name.toLowerCase().startsWith(text.toLowerCase())) {
											is_finded = true;
											skills_hint.add(skill.name);
										}
									}
									filters.skills_hint = skills_hint;
									if (!is_finded) {
										filters.skills_hint = [];
									}
								}
							});
						},
						decoration: InputDecoration(
							border: OutlineInputBorder(
								borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
			);
		}

		Widget form_name = Form(
			key: _form_key_name,
			child: Padding(
				padding: form_padding,
				child: TextFormField(
					controller: name_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Ім’я не може бути пустим';
						}
						return null;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_name.currentState!.validate())
								button_states[name_index] = true;
							else
								button_states[name_index] = false;
						});
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Напишіть назву',
						suffixIcon: IconButton(
							onPressed: name_controller.clear,
							icon: Icon(
								Icons.clear,
							),
						),
					),
				),
			),
		);

		Widget form_bio = Form(
			key: _form_key_bio,
			child: Padding(
				padding: form_padding,
				child: TextFormField(
					minLines: 5,
					maxLines: 8,
					maxLength: 375,
					controller: bio_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Ім’я не може бути пустим';
						}
						return null;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_bio.currentState!.validate())
								button_states[bio_index] = true;
							else
								button_states[bio_index] = false;
						});
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: (event_for == Roles.volunteer ) ?
						'Напишіть про задачі волонтерів й загальний напрям роботи...' :
						'Напишіть про допомогу, яку можете надати...' ,
					),
				),
			),
		);

		Widget form_location = Form(
			key: _form_key_location,
			child: Padding(
				padding: form_padding,
				child: TextFormField(
					controller: location_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Ім’я не може бути пустим';
						}
						return null;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_location.currentState!.validate())
								button_states[location_index] = true;
							else
								button_states[location_index] = false;
						});
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Напишіть назву',
						suffixIcon: IconButton(
							onPressed: location_controller.clear,
							icon: Icon(
								Icons.clear,
							),
						),
					),
				),
			),
		);

		Widget form_members = Form(
			key: _form_key_members,
			child: Padding(
				padding: form_padding,
				child: Align(
					alignment: Alignment.bottomLeft,
					child: SizedBox(
						width: 119,
						child: TextFormField(
							keyboardType: TextInputType.number,
							controller: members_controller,
							autovalidateMode: AutovalidateMode.onUserInteraction,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Кількість місць не може бути пустим';
								}
								return null;
							},
							onChanged: (text) {
								setState(() {
									if (_form_key_members.currentState!.validate())
										button_states[recuired_people_index] = true;
									else
										button_states[recuired_people_index] = false;
								});
							},
							decoration: InputDecoration(
								border: const OutlineInputBorder(
									borderRadius : BorderRadius.all(Radius.circular(16.0)),
								),
								hintText: 'к-ть',
								suffixIcon: IconButton(
									onPressed: members_controller.clear,
									icon: Icon(
										Icons.clear,
									),
								),
							),
						),
					),
				),
			),
		);


		Widget edit_forms({Event? event}){
			late Widget image_widget;
			if (event != null && !one_time_counter) {
				for (int i=0; i< button_states.length; i++) {
						button_states[i] = true;
				}
				filters.city = event.city;
				filters.employment =  int_to_employments(event.employment);
				name_controller.text = event.name;
				bio_controller.text = event.description;
				location_controller.text = event.location;
				members_controller.text = event.required_members.toString();
				filters.date_start = DateTime.tryParse(event.end_time);
				filters.date_end = DateTime.tryParse(event.end_time);
				filters.time_start = TimeOfDay.fromDateTime(filters.date_start!);
				filters.time_end = TimeOfDay.fromDateTime(filters.date_end!);

				image_widget = Image(
						image: CachedNetworkImageProvider(event.image),
						fit: BoxFit.fitWidth
				);
			}
			else {
				image_widget = Image.asset(
					'images/img_25.png',
					fit: BoxFit.fitWidth,
				);
			}

			return Column(
				children: [
					GestureDetector(
						onTap: () async {
							image = await ImagePicker().pickImage(source: ImageSource.gallery);
							if (image!= null) {
								setState(() {
									button_states[image_index] = true;
								});
							}

						},
						child: Padding(
							padding: form_padding,
							child: ClipRRect(
								borderRadius: BorderRadius.circular(20.0),
								child: ConstrainedBox(
									constraints: const BoxConstraints(
										minWidth: 70,
										minHeight: 80,
										maxWidth: double.infinity,
										maxHeight: 450,
									),
									child: (button_states[image_index] && (image != null) && (image?.path != null)) ?
									Image.file(
										File(image?.path ?? ''),
										fit: BoxFit.fitWidth,
									) : image_widget,
								),
							),
						),
					),
					build_bold_left_text(
						'Назва',
						padding: header_padding,
					),
					form_name,
					build_bold_left_text(
						'Опис',
						padding: header_padding,
					),
					form_bio,


					build_bold_left_text(
						'Вміння',
						padding: header_padding,
					),

					FutureBuilder<Skills>(
						//TODO RangeErrror (index) in creating new event
						future: futureSkills,
						builder: (context, snapshot) {
							if (snapshot.hasData) {

								if (!one_time_counter) {
									one_time_counter = true;
									filters.skills_list = [];
									snapshot.data?.list.forEach((element){
										if (event != null && event.skills.contains(element.id)) {
											filters.skills_list.add(element.name);
										}
										skill_map[element.name] = element.id;
									});
								}

								return Column(
									children: [

										form_skills(snapshot.data!),

										filters.skills_hint.isNotEmpty
												? build_helpers_text(filters.skills_hint, (String helper) {
											dPrint('hint early ${helper}');

											setState(() {
												skills_controller.text = '';
												filters.skills_hint = [];
												if (!filters.skills_list.contains(helper))
													filters.skills_list.add(helper);
												dPrint('skillcard hint ${helper}');

											});
										})
												: Container(),

										filters.skills_list.isNotEmpty
												? build_skills_columns(
											data: filters.skills_list,
											// context: context,
											width: MediaQuery.of(context).size.width.floor() - 70,
											app_service: _app_service,
											fun: (String helper) {
												dPrint('skillcard early ${helper}');
												setState(() {
													// var index = _app_service.skills.indexOf(helper);
													if (filters.skills_list.indexOf(helper) >= 0) {
														filters.skills_list.removeAt(filters.skills_list.indexOf(helper));
													}
													dPrint('_app_service.skills ${filters.skills_list}');
												});
											},
										)
												: Container(),

									],
								);

							} else if (snapshot.hasError) {
								return build_no_internet(error: snapshot.error.toString());

							}

							return const CircularProgressIndicator();
						},
					),



					build_bold_left_text(
						'Місто',
						padding: header_padding,
					),
					FutureBuilder<Cities>(
						future: futureCities,
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								filters.set_city_aliases(snapshot.data!.list!);
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
														filters.city_hint = [];
													});
												},
											) :
											buildCityCard(
												id: 6,
												title: 'Інше',
												fun: (String helper) {
													setState(() {
														city_controller.text = helper;
														filters.city_hint = [];
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

					build_bold_left_text(
						'Локація',
						padding: header_padding,
					),
					form_location,

					build_bold_left_text(
						'Зайнятість',
						padding: header_padding,
					),

					build_employments_rows(
						data: employments_text.values,
						// context: context,
						width: MediaQuery.of(context).size.width.floor() - 20,
						app_service: _app_service,
						fun: (String helper) {
						},
					),


					build_bold_left_text(
						'Дата',
						padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
					),

					Row(
						children: [
							build_left_text('Початок'),

							build_date_picker(
								context: context,
								controller: start_date_controller,
								app_service: _app_service,
								is_start: true,
							),

							build_time_picker(
								context: context,
								controller: start_time_controller,
								app_service: _app_service,
								is_start: true,
							),

						],
					),


					Row(
						children: [
							build_left_text('Кінець   '),

							build_date_picker(context: context,
								controller: end_date_controller,
								app_service: _app_service,
								is_start: false,
							),

							build_time_picker(context: context,
								controller: end_time_controller,
								app_service: _app_service,
								is_start: false,
							),

						],
					),

					build_bold_left_text(
						'Кількість місць',
						padding: header_padding,
					),
					form_members,

					welcome_button_fun(
						text: 'Опублікувати',
						padding: [0, 19, 0, 14],
						fun: is_ready_to_submit() ?
								() async {
							filters.event_active = true;
							submit();
						} : null,
					),
					is_edit_event ? social_button(
						text: 'Відмінити івент',
						padding: [0, 0, 0, 19],
						fun: () {
							if (event != null) _showCancelDialog(context, event);
						}

					) : Container(),

				],
			);
		}


			return Scaffold(
				appBar: buildAppBar(
								() {
									is_edit_event ?
													context.go(APP_PAGE.my_events.to_path) :
													Navigator.pop(context);
									},
						is_edit_event ? 'Редагувати івент' : 'Новий івент',
						TextButton(
							onPressed: is_ready_to_submit() ?
									() async {
										filters.event_active = null;
								await submit();
							}
									: null,
							child: Text(
								'Готово',
								style: TextStyle(
									fontSize: 18,
									fontFamily: 'SF Pro Text',
									fontWeight: FontWeight.w400,
								),
							),
						)
				),

				body: SingleChildScrollView(
					child: is_edit_event ?
					FutureBuilder<Event>(
						future: fetchEvent(int.tryParse(widget.event_for_or_edit)!, _app_service),
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								filters.event_active = snapshot.data?.active ?? true;
								return edit_forms(event: snapshot.data);

							} else if (snapshot.hasError) {
								return build_no_internet(error: snapshot.error.toString());
							}

							return const CircularProgressIndicator();
						},
					) : edit_forms(),

				),
				bottomNavigationBar: const buildBottomNavigationBar(),

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
		required AppService app_service,
		required bool is_start,
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
							if (is_start)
								filters.date_start = pickedDate;
							else
								filters.date_end = pickedDate;

						});
					}else{
						dPrint("Date is not selected");
					}
				},
			)
		);
	}

	Widget build_time_picker({
				required BuildContext context,
				required TextEditingController controller,
				required AppService app_service,
				required bool is_start,

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
								if (is_start)
									filters.time_start = pickedTime;
								else
									filters.time_end = pickedTime;
							});
						}else{
							dPrint("Time is not selected");
						}
					},
				)
		);
	}


}