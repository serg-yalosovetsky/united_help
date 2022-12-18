import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

var form_padding = const EdgeInsets.fromLTRB(16, 13, 16, 0);
var header_padding = const EdgeInsets.fromLTRB(0, 0, 8, 0);

class NewEventScreen extends StatefulWidget {
	const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}


Widget build_skills_columns({
			required data,
			required BuildContext context,
			required AppService app_service,
			required Function fun,
			Widget? form_city}
			) {
	List<String> cities_list = [];
	Map<int, String> cities_alias = {};
	data.forEach((element) {cities_list.add(element.city); });
	data.forEach((element) {cities_alias[element.alias]; });
	if (form_city != null)
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
	required BuildContext context,
	required AppService app_service,
	required Function fun,
	}
		) {
	List<String> cities_list = [];
	data.forEach((element) {cities_list.add(element); });
	var cities_card_blueprint = calculate_cities_widgets(
		context: context,
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

class _NewEventScreenState extends State<NewEventScreen> {
	List<bool> button_states = [false, false, false, false, false];
	final int name_index = 0;
	final int bio_index = 1;
	final int location_index = 2;
	final int city_index = 3;
	final int skills_index = 4;
	final int recuired_people_index = 5;

	late Future<Skills> futureSkills;
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
		start_date_controller.text = "";
		start_time_controller.text = "";
		end_date_controller.text = "";
		end_time_controller.text = "";
		_app_service = Provider.of<AppService>(context, listen: false);
		futureSkills = fetchSkills(skills_query, _app_service);
		futureCities = fetchCities(cities_query, _app_service);
		super.initState();
	}

	@override
	Widget build(BuildContext context) {

		Widget form_city = Form(
			key: _form_key_city,
			child: Padding(
						padding: form_padding,
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
									Map<String, String> alias = {'Кyiv' : 'Kyiv Kiev', 'Korostishev' : 'Korostishev', 'Odesa': 'Odesa'};
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
			Map<String, String> alias = {'Кyiv' : 'Kyiv Kiev', 'Korostishev' : 'Korostishev', 'Odesa': 'Odesa'};

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

		Widget form_skills = Form(
			key: _form_key_skills,
			child: Padding(
				padding: form_padding,
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
										print('contain!! $skill');
										is_finded = true;
										// _app_service.city_hint = [city];
								}
							}
							if (!is_finded){
								_app_service.skills_hint = [];
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
										print(skill);
										if (skill.toLowerCase().startsWith(text.toLowerCase())) {
											print('contain!! $skill');
											is_finded = true;
											skills_hint.add(skill);
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
		);

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
					decoration: const InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Напишіть про задачі волонтерів й загальний напрям роботи...',
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

		return Scaffold(
			appBar: buildAppBar(
					null,
					'Новий івент',
					TextButton(
						onPressed: () {},
						child: Text(
							'Готово',
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
			  child: Column(
			    children: [
						Container(
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
							  		child: Image.asset(
							  				'images/img_25.png',
							  				fit: BoxFit.fitWidth
							  		),
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

						form_skills,
						_app_service.skills_hint.isNotEmpty
								? build_helpers_text(_app_service.skills_hint, (String helper) {
							setState(() {
								skills_controller.text = helper;
								_app_service.skills_hint = [];
							});
						})
								: Container(),



						build_bold_left_text(
			  			'City',
			  			padding: header_padding,
			  		),
			      FutureBuilder<Cities>(
			  			future: futureCities,
			  			builder: (context, snapshot) {
			  				if (snapshot.hasData) {
			  					return build_skills_columns(
			  						data: snapshot.data!.list,
			  						context: context,
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
			  			context: context,
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

								build_date_picker(context: context,
										controller: start_date_controller,
										app_service_link: _app_service.data_start),

								build_time_picker(context: context,
										controller: start_time_controller,
										app_service_link: _app_service.time_start),

						  ],
						),


						Row(
							children: [
								build_left_text('Кінець   '),

								build_date_picker(context: context,
										controller: end_date_controller,
										app_service_link: _app_service.data_end),

								build_time_picker(context: context,
																	controller: end_time_controller,
																	app_service_link: _app_service.time_end),

							],
						),

						build_bold_left_text(
							'Кількість місць',
							padding: header_padding,
						),
						form_members,
						Padding(padding: header_padding,)
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