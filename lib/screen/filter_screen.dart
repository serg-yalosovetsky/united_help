import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/services/appservice.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../fragment/data_picker.dart';
import '../fragment/skill_card.dart';
import '../fragment/text_field_helper.dart';
import '../helpers.dart';
import '../models/events.dart';
import '../models/filter.dart';
import '../routes/routes.dart';
import '../fragment/skill_card.dart';
import 'package:intl/intl.dart';


class FiltersCard extends StatefulWidget {
	const FiltersCard({super.key});

  @override
  State<FiltersCard> createState() => _FiltersCardState();
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

class _FiltersCardState extends State<FiltersCard> {
	late Future<Skills> futureSkills;
	late Future<Cities> futureCities;
	final String skills_query = '';
	final String cities_query = '';
	late AppService _app_service;
	final _form_key_city = GlobalKey<FormState>();
	final _form_key_skills = GlobalKey<FormState>();
	final city_controller = TextEditingController();
	final skills_controller = TextEditingController();

	TextEditingController dateController = TextEditingController();
	TextEditingController timeController = TextEditingController();
	String _selectedDate = '';
	String _dateCount = '';
	String _range = '';
	String _rangeCount = '';
	/// The method for [DateRangePickerSelectionChanged] callback, which will be
	/// called whenever a selection changed on the date picker widget.
	void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
		/// The argument value will return the changed date as [DateTime] when the
		/// widget [SfDateRangeSelectionMode] set as single.
		///
		/// The argument value will return the changed dates as [List<DateTime>]
		/// when the widget [SfDateRangeSelectionMode] set as multiple.
		///
		/// The argument value will return the changed range as [PickerDateRange]
		/// when the widget [SfDateRangeSelectionMode] set as range.
		///
		/// The argument value will return the changed ranges as
		/// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
		/// multi range.
		setState(() {
			if (args.value is PickerDateRange) {
				_range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
				// ignore: lines_longer_than_80_chars
						' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
			} else if (args.value is DateTime) {
				_selectedDate = args.value.toString();
			} else if (args.value is List<DateTime>) {
				_dateCount = args.value.length.toString();
			} else {
				_rangeCount = args.value.length.toString();
			}
		});
	}


	@override
  void dispose() {
		city_controller.dispose();
		skills_controller.dispose();
		dateController.dispose();
		timeController.dispose();
		super.dispose();
  }

	@override
	void initState() {
		dateController.text = ""; //set the initial value of text field
		timeController.text = ""; //set the initial value of text field
		_app_service = Provider.of<AppService>(context, listen: false);
		futureSkills = fetchSkills(skills_query);
		futureCities = fetchCities(cities_query);
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

			body: SingleChildScrollView(
			  child: Column(
			    children: [
			  		build_bold_left_text(
			  			'Локація',
			  			padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
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
			  					return Text('${snapshot.error}');
			  				}

			  				return const CircularProgressIndicator();
			  				},
			  			),
			  		build_bold_left_text(
			  			'Зайнятість',
			  			padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
			  		),

			  		build_employments_rows(
			  			data: employments_text.values,
			  			context: context,
			  			app_service: _app_service,
			  			fun: (String helper) {
			  			},
			  		),

			  		build_bold_left_text(
			  			'Вміння',
			  			padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
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
							'Дата',
							padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
						),
						
						// Row(children: [
						// 	// Text('Початок'),
						// 	SfDateRangePicker(
						// 		onSelectionChanged: _onSelectionChanged,
						// 		selectionMode: DateRangePickerSelectionMode.range,
						// 		initialSelectedRange: PickerDateRange(
						// 				DateTime.now().subtract(const Duration(days: 4)),
						// 				DateTime.now().add(const Duration(days: 3))),
						// 	),
						// 	// DataPickerButton(),
						// 	// buildEmploymentCard(title: 'c')
						// ],),

						// Stack(
						// 	children: <Widget>[
						// 		Positioned(
						// 			left: 0,
						// 			right: 0,
						// 			top: 0,
						// 			height: 80,
						// 			child: Column(
						// 				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						// 				mainAxisSize: MainAxisSize.min,
						// 				crossAxisAlignment: CrossAxisAlignment.start,
						// 				children: <Widget>[
						// 					Text('Selected date: $_selectedDate'),
						// 					Text('Selected date count: $_dateCount'),
						// 					Text('Selected range: $_range'),
						// 					Text('Selected ranges count: $_rangeCount')
						// 				],
						// 			),
						// 		),
						// 		Positioned(
						// 			left: 0,
						// 			top: 80,
						// 			right: 0,
						// 			bottom: 0,
						// 			child: SfDateRangePicker(
						// 				onSelectionChanged: _onSelectionChanged,
						// 				selectionMode: DateRangePickerSelectionMode.range,
						// 				initialSelectedRange: PickerDateRange(
						// 						DateTime.now().subtract(const Duration(days: 4)),
						// 						DateTime.now().add(const Duration(days: 3))),
						// 			),
						// 		)
						// 	],
						// ),


						Row(
						  children: [
								Padding(
								  padding: const EdgeInsets.fromLTRB(17.0, 0, 0, 0),
								  child: Text('Початок',
								  			style: TextStyle(
								  				fontSize: 17,
								  				fontWeight: FontWeight.w500
								  			),
								  ),
								),

								Container(
						    		padding:const EdgeInsets.all(15),
						    		// height:150,
						    		width: 140,
						    		child: TextField(

						    			controller: dateController, //editing controller of this TextField
						    			decoration: const InputDecoration(

						    					// icon: Icon(Icons.calendar_today), //icon of text field
						    					// labelText: "Enter Date" //label text of field
						    			),
						    			readOnly: true,  // when true user cannot edit text
						    			onTap: () async {
						    				DateTime? pickedDate = await showDatePicker(
						    						context: context,
						    						initialDate: DateTime.now(), //get today's date
						    						firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
						    						lastDate: DateTime(2101)
						    				);

						    				if(pickedDate != null ){
						    					print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
						    					String formattedDate = DateFormat('EEE, MMM dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
						    					print(formattedDate); //formatted date output using intl package =>  2022-07-04
						    					//You can format date as per your need

						    					setState(() {
						    						dateController.text = formattedDate; //set foratted date to TextField value.
						    					});
						    				}else{
						    					print("Date is not selected");
						    				}
						    			},
						    		)
						    ),

								Container(
										padding:const EdgeInsets.all(15),
										// height:150,
										width: 140,
										child: TextField(

											controller: timeController, //editing controller of this TextField
											decoration: const InputDecoration(

													// icon: Icon(Icons.calendar_today), //icon of text field
													// labelText: "Enter time" //label text of field
											),
											readOnly: true,  // when true user cannot edit text
											onTap: () async {
												TimeOfDay? pickedDate = await showTimePicker(
														context: context,
														initialTime: TimeOfDay.now(), //get today's date
														// firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
														// lastDate: DateTime(2101)
												);

												if(pickedDate != null ){
													// ${pickedDate.hour} ${pickedDate.minute}
													print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
													String formattedTime = '${pickedDate.hour}:${pickedDate.minute} ${pickedDate.period.name.toUpperCase()}'; // format date in required form here we use yyyy-MM-dd that means time is removed
													print(DateFormat); //formatted date output using intl package =>  2022-07-04
													//You can format date as per your need

													setState(() {
														timeController.text = formattedTime; //set foratted date to TextField value.
													});
												}else{
													print("Date is not selected");
												}
											},
										)
								),

						  ],
						),



			  	],
			  ),
			),

		);
	}
}