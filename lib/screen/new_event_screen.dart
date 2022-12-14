import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/services/appservice.dart';
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

var form_padding = const EdgeInsets.fromLTRB(16, 13, 16, 0);
var header_padding = const EdgeInsets.fromLTRB(0, 0, 8, 0);

class NewEventScreen extends StatefulWidget {
	final String event_for;
	const NewEventScreen({
		super.key,
		required this.event_for,
	});

  @override
  State<NewEventScreen> createState() => NewEventScreenState();
}


Widget build_skills_columns({
			required data,
			// required BuildContext context,
			required int width,
			required AppService app_service,
			required Function fun,
			}) {
	List<String> skills_list = [];
	data.forEach((element) {skills_list.add(element); });
	var skills_card_blueprint = calculate_cities_widgets(
		// context: context,
		width: width,
		cities_list: skills_list,
		max_columns: 2,
	);
	var cr = <Widget>[];
	int index = 0;
	for (var row in skills_card_blueprint){
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

Widget build_cities_columns({
	required data,
	// required BuildContext context,
	required int width,
	required AppService app_service,
	required Function fun,
	Widget? form_city}
		) {
	print('\n\n');
	print('width= $width');
	print('\n\n');
	List<String> cities_list = [];
	Map<int, String> cities_alias = {};
	data.sublist(0, 5).forEach((element) {cities_list.add(element.city); });
	data.sublist(0, 5).forEach((element) {cities_alias[element.alias]; });
	if (form_city != null)
		cities_list.add('????????');
	var cities_card_blueprint = calculate_cities_widgets(
		// context: context,
		width: width,
		cities_list: cities_list,
		max_columns: 2,
	);
	var cr = <Widget>[];
	int index = 0;
	for (var row in cities_card_blueprint){
		var rc = <Widget>[];
		for (var city in row){
			rc.add(buildCityCard(title: city, id:index));
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
			(form_city != null) && app_service.open_text_field_choose_other_city ? form_city : Container(),
			app_service.open_text_field_choose_other_city && app_service.city_hint.isNotEmpty
					? build_helpers_text(app_service.city_hint, (String helper) {
				fun(helper);
			}) : Container(),
		],
	);


	return c;

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


class NewEventScreenState extends State<NewEventScreen> {

	final int image_index = 0;
	final int name_index = 1;
	final int bio_index = 2;
	final int location_index = 3;
	final int recuired_people_index = 4;
	List<bool> button_states = List<bool>.generate(5, (index) => false);

	late Future<Skills> futureSkills;
	late Roles event_for;
	late Future<Cities> futureCities;
	final String skills_query = '';
	final String cities_query = '';
	late AppService _app_service;
	final _form_key_name = GlobalKey<FormState>();
	final _form_key_bio = GlobalKey<FormState>();
	final _form_key_location = GlobalKey<FormState>();
	final _form_key_city = GlobalKey<FormState>();
	final _form_key_skills = GlobalKey<FormState>();
	final _form_key_members = GlobalKey<FormState>();
	final name_controller = TextEditingController();
	final bio_controller = TextEditingController();
	final location_controller = TextEditingController();
	final city_controller = TextEditingController();
	final skills_controller = TextEditingController();
	final members_controller = TextEditingController();
	Map skill_map = {};
	TextEditingController start_date_controller = TextEditingController();
	TextEditingController start_time_controller = TextEditingController();
	TextEditingController end_date_controller = TextEditingController();
	TextEditingController end_time_controller = TextEditingController();

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
		super.dispose();
  }

	@override
	void initState() {
		_app_service = Provider.of<AppService>(context, listen: false);
		start_date_controller.text = date_to_str(DateTime.now());
		start_time_controller.text = time_to_str(TimeOfDay.now());
		end_date_controller.text = date_to_str(DateTime.now());
		end_time_controller.text = time_to_str(TimeOfDay.now());
		_app_service.data_start = DateTime.now();
		_app_service.data_end = DateTime.now();
		_app_service.time_start = TimeOfDay.now();
		_app_service.time_end = TimeOfDay.now();

		futureSkills = fetchSkills(skills_query, _app_service);
		futureCities = fetchCities(cities_query, _app_service);
		super.initState();
	}
	XFile? image = null;

	bool is_ready_to_submit() {
		return button_states.every((element) => element==true) &&
				(_app_service.filter_city>-1) && (_app_service.filter_employment>-1);
	}

	submit() async {
		print(11);
		Event event = Event(
				id: 0,
				name: name_controller.text,
				enabled: true,
				description: bio_controller.text,
				reg_date: '',
				start_time: DateTime(
					_app_service.data_start?.year ?? 0,
					_app_service.data_start?.month ?? 0,
					_app_service.data_start?.day ?? 0,
					_app_service.time_start?.hour ?? 0,
					_app_service.time_start?.minute ?? 0,
				).toString(),
				end_time: DateTime(
					_app_service.data_end?.year ?? 0,
					_app_service.data_end?.month ?? 0,
					_app_service.data_end?.day ?? 0,
					_app_service.time_end?.hour ?? 0,
					_app_service.time_end?.minute ?? 0,
				).toString(),
				image: image?.path ?? '',
				city: _app_service.filter_city,
				location: location_controller.text,
				employment: _app_service.filter_employment,
				owner: 0,
				to: roles_2_int(event_for),
				skills: List.generate(
						_app_service.skills.length,
						(index) => skill_map[_app_service.skills[index]],
				) ,
				required_members: int.parse(members_controller.text),
				subscribed_members: 0,
		);
		var res = await postEvents(event.to_dict(), _app_service);
		context.go(APP_PAGE.my_events.to_path);
		// return res['success'] as bool;
	}

	@override
	Widget build(BuildContext context) {
		if (widget.event_for == Roles.refugee.toString()) {
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
									return '???????? ??????????, ?????????????? ?????????? ??????????????';
								}
								else{
									Map<String, String> alias = {'??yiv' : 'Kyiv Kiev', 'Korostishev' : 'Korostishev', 'Odesa': 'Odesa'};
									bool is_finded = false;
									for (var city in alias.keys){
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
										return '?????????????? ???? ???????????????? :(';
									}
								}

								return null;
							},
							onChanged: (text) {
								setState(() {
									if (text.isEmpty){
											// _form_key_city.currentState!.validate();
									} else {
                    print(text);
										Map<String, String> alias = {'??yiv' : 'Kyiv Kiev', 'Korostishev' : 'Korostishev', 'Odesa': 'Odesa'};

										bool is_finded = false;
										List<String> cities_hint = [];
                    for (var city in alias.keys) {
                      print(city);
                      print(alias[city]);
                      for (var alia in alias[city]!.split(' ')) {
                        if (alia.toLowerCase().startsWith(text.toLowerCase())) {
                          print('contain!! $city');
                          is_finded = true;
													cities_hint.add(city);
                        }
                      }
                    }
										_app_service.city_hint = cities_hint;

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
								hintText: '??????????????',
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
										print(skill);
										if (skill.name.toLowerCase().startsWith(text.toLowerCase())) {
											print('contain!! $skill');
											is_finded = true;
											skills_hint.add(skill.name);
										}
									}
									_app_service.skills_hint = skills_hint;
									if (!is_finded) {
										_app_service.skills_hint = [];
									}
								}
							});
						},
						decoration: InputDecoration(
							border: OutlineInputBorder(
								borderRadius: BorderRadius.all(Radius.circular(16.0)),
							),
							hintText: '????????????????',
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
							return '????????? ???? ???????? ???????? ????????????';
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
						hintText: '???????????????? ??????????',
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
							return '????????? ???? ???????? ???????? ????????????';
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
						'???????????????? ?????? ???????????? ???????????????????? ?? ?????????????????? ???????????? ????????????...' :
						'???????????????? ?????? ????????????????, ?????? ???????????? ????????????...' ,
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
							return '????????? ???? ???????? ???????? ????????????';
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
						hintText: '???????????????? ??????????',
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
									return '?????????????????? ?????????? ???? ???????? ???????? ????????????';
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
								hintText: '??-????',
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

		return Scaffold(
				appBar: buildAppBar(
								() {Navigator.pop(context);},
						'?????????? ??????????',
						TextButton(
							onPressed: is_ready_to_submit() ?
									() async {
										await submit();
									}
									: null,
							child: Text(
								'????????????',
								style: TextStyle(
									// color: Color(0xFF0071D8),
									fontSize: 18,
									fontFamily: 'SF Pro Text',
									fontWeight: FontWeight.w400,
								),
							),
						)
				),

				body: SingleChildScrollView(
					child: Column(
						children: [
							GestureDetector(
								onTap: () async {
									image = await ImagePicker().pickImage(source: ImageSource.gallery);
									if (image!= null) {
										// image?.saveTo('images/user_new_event.png');
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
											) :
											Image.asset(
												'images/img_25.png',
												fit: BoxFit.fitWidth,
											),
										),
									),
								),
							),
							build_bold_left_text(
								'??????????',
								padding: header_padding,
							),
							form_name,
							build_bold_left_text(
								'????????',
								padding: header_padding,
							),
							form_bio,


							build_bold_left_text(
								'????????????',
								padding: header_padding,
							),

							FutureBuilder<Skills>(
								future: futureSkills,
								builder: (context, snapshot) {
									if (snapshot.hasData) {

										snapshot.data?.list.forEach((element) {
													skill_map[element.name] = element.id;
										});
										return Column(
											children: [

												form_skills(snapshot.data!),

												_app_service.skills_hint.isNotEmpty
														? build_helpers_text(_app_service.skills_hint, (String helper) {
													print('hint early ${helper}');

													setState(() {
														skills_controller.text = '';
														_app_service.skills_hint = [];
														if (!_app_service.skills.contains(helper))
																_app_service.skills.add(helper);
														print('skillcard hint ${helper}');

													});
												})
														: Container(),

												_app_service.skills.isNotEmpty
														? build_skills_columns(
													data: _app_service.skills,
													// context: context,
													width: MediaQuery.of(context).size.width.floor() - 70,
													app_service: _app_service,
													fun: (String helper) {
														print('skillcard early ${helper}');
														setState(() {
															// var index = _app_service.skills.indexOf(helper);
															if (_app_service.skills.indexOf(helper) >= 0) {
																_app_service.skills.removeAt(_app_service.skills.indexOf(helper));
															}
															print('_app_service.skills ${_app_service.skills}');
														});
													},
												)
														: Container(),

											],
										);

									} else if (snapshot.hasError) {
										// return Text('${snapshot.error}');
										return build_no_internet();

									}

									return const CircularProgressIndicator();
								},
							),



							build_bold_left_text(
								'??????????',
								padding: header_padding,
							),
							FutureBuilder<Cities>(
								future: futureCities,
								builder: (context, snapshot) {
									if (snapshot.hasData) {
										return build_cities_columns(
											data: snapshot.data!.list,
											width: MediaQuery.of(context).size.width.floor() - 50,
											// context: context,
											app_service: _app_service,
											fun: (String helper) {
												setState(() {
													city_controller.text = helper;
													_app_service.city_hint = [];
												});
											},
											form_city: form_city,
										);

									} else if (snapshot.hasError) {
										// return Text('${snapshot.error}');
										return build_no_internet();

									}

									return const CircularProgressIndicator();
								},
							),

							build_bold_left_text(
								'??????????????',
								padding: header_padding,
							),
							form_location,

							build_bold_left_text(
								'????????????????????',
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
								'????????',
								padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
							),

							Row(
								children: [
									build_left_text('??????????????'),

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
									build_left_text('????????????   '),

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
								'?????????????????? ??????????',
								padding: header_padding,
							),
							form_members,
							
							welcome_button_fun(
								text: '????????????????????????',
								padding: [0, 19, 0, 46],
								fun: is_ready_to_submit() ?
									() async {
										submit();
								} : null,
							),

							// social_button(
							// 	text: '?????????????????? ??????????',
							// 	padding: [0, 19, 0, 46],
							// 	fun: is_ready_to_submit() ?
							// 			() async {
							// 		submit();
							// 	} : null, icon: null,
							// ),
							
						],
					),
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
									app_service.data_start = pickedDate;
							else
									app_service.data_end = pickedDate;

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
									app_service.time_start = pickedTime;
								else
									app_service.time_end = pickedTime;
							});
						}else{
							print("Time is not selected");
						}
					},
				)
		);
	}


}