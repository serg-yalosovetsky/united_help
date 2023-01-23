import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/screen/edit_account.dart';
import 'package:united_help/screen/settings_screen.dart';
import 'package:united_help/providers/appservice.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/card_list.dart';
import '../fragment/events_list.dart';
import '../fragment/no_internet.dart';
import '../fragment/skill_card.dart';
import '../models/profile.dart';


class AccountScreen extends StatelessWidget {
	final int user_id;
	const AccountScreen({
		super.key,
		this.user_id = 0,
	});
	void _showDialog(BuildContext context) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text("Alert!!"),
					content: Text("NotImplementedError"),
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
		 AppService app_service = Provider.of<AppService>(context, listen: false);

		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Row(
					children: [
						GestureDetector(
						  onTap: () {
								Navigator.pop(context);
							},
							child: Row(
						  		children: [
						  			Icon(Icons.arrow_back_ios, size: 23,),
						  			const Text(
						  				'Назад',
						  				style: back_style,
						  			),
						  		],
						  ),
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
				actions: user_id==0 ? [
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
								Navigator.of(context).push(
									MaterialPageRoute(
										builder: (context) => build_settings_screen(),
									),
								);
							} else if (value == 2) {
								_showDialog(context);
							}
							else if (value == 3) {
								app_service.logout();
							}
						},
					),
				] : null,
			),
			body: SafeArea(
				child: account_screen(user_id: user_id),
			),
			bottomNavigationBar: buildBottomNavigationBar(),

		);
	}
}



class account_screen extends StatefulWidget {
	final int user_id;
	const account_screen({
		Key? key,
		required this.user_id,
	}) : super(key: key);


	static const TextStyle optionStyle =
	TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
	static const TextStyle timerStyle = TextStyle(
		fontSize: 18,
	);
	static const TextStyle timerBoldStyle =
	TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  State<account_screen> createState() => _account_screenState();
}

class _account_screenState extends State<account_screen> {

	Widget return_skills_card(List skills, [int skill_in_row = 2]) {
		List<Widget> columns = [];
		int i = 0;
		while (i <= skills.length/2.ceil()) {
			List<Widget> rows = [];
			if (i < skills.length) rows.add(buildCityCard(title: skills[i], id: 0));
			if (i + 1 < skills.length) rows.add(buildCityCard(title: skills[i+1], id: 0));
			Widget row_widget = Row(
				children: rows,
			);
			columns.add(row_widget);
			i = i +2;
		}
		return Column(children: columns);
	}

	late AppService _app_service;
	@override
  void initState() {
		_app_service = Provider.of<AppService>(context, listen: false);
    super.initState();
  }
	@override
	Widget build(BuildContext context) {
		User? user = _app_service.user;
		Profile? profile = _app_service.current_profile;

		if (user == null || profile == null || widget.user_id!=0) {
		  return FutureBuilder<UserProfile>(
					future: fetchUserProfile('${widget.user_id}', _app_service),
					builder: (context, snapshot){
						if (snapshot.hasData){
							if (widget.user_id != 0) {
								_app_service.user = snapshot.data!.user;
								_app_service.current_profile = snapshot.data!.profile;
							}

							return build_account_screen(
								userprofile: snapshot.data!,
								app_service: _app_service,
							);
						} else if (snapshot.hasError) {
							return build_no_internet(error: snapshot.error.toString());
						}
						return const CircularProgressIndicator();
					},
			);
		} else {
			return build_account_screen(
				userprofile: UserProfile(user: user, profile: profile),
				app_service: _app_service,
			);
		}


	}
}

class build_account_screen extends StatefulWidget {
  const build_account_screen({
    Key? key,
		// required this.userprofile,
		required this.userprofile,
		required this.app_service,
  }) : super(key: key);

	// final UserProfile userprofile;
	final UserProfile userprofile;
	final AppService app_service;
	static const TextStyle timerBoldStyle =
													TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  State<build_account_screen> createState() => _build_account_screenState();
}

class _build_account_screenState extends State<build_account_screen> {
  @override
  Widget build(BuildContext context) {
		// Profile profile = userprofile[user_profile.profile] as Profile;
		// User user = userprofile[user_profile.user] as User;
		var image;
		if (widget.userprofile.profile.image != null) {
			if (widget.app_service.user_image_expire){
				image = FutureBuilder(
					future: fetchProfileImage(widget.app_service),
					builder: (context, snapshot) {
						String? image_url = widget.app_service.current_profile?.image ?? '';
						if (snapshot.hasData){
							image_url = snapshot.data as String?;
						}
						widget.app_service..current_profile?.image = image_url;
						widget.app_service.user_image_expire = false;
						return Image.network(
							image_url ?? widget.app_service.current_profile?.image ?? '',
						);
					},
				);
			}
			image = NetworkImage(widget.userprofile.profile.image!);
		 } else {
			image = AssetImage('images/img_22.png');
		}

    return SafeArea(
    		child: Center(
    		  child: SingleChildScrollView(
    		    child: Column(
						mainAxisSize: MainAxisSize.min,
    		    	crossAxisAlignment: CrossAxisAlignment.center,
    		    	mainAxisAlignment: MainAxisAlignment.start,
    		    	children: [
							Column(
								children: [
										Padding(
										padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
										child: GestureDetector(
										  child: CircleAvatar(
										  	foregroundImage: image,
									radius: 50.0,
										  ),
											onTap: () {
												Navigator.of(context).push(
													MaterialPageRoute(
														builder: (context) => const EditAccountScreen(),
													),
											);},
										),
									),

										Padding(
											padding: const EdgeInsets.fromLTRB(73, 15, 73, 0),
											child: Text(
													widget.userprofile.user.username,
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
											child: Text(
													widget.userprofile.profile.description ?? 'В вас немає біо',
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
													style: build_account_screen.timerBoldStyle,
												),
											),
										),

										widget.userprofile.user.phone!=null ? Container(
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
															widget.userprofile.user.phone!,
														style: TextStyle(
																color: Color(0xff002241),
																fontSize: 18,
																fontWeight: FontWeight.w400
														),
													),
												],
											),
										),
									) : Container(),

										widget.userprofile.user.nickname!=null ? Container(
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
																widget.userprofile.user.nickname!,
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
										) : Container(),
						],
					),
							Column(
								mainAxisSize: MainAxisSize.max,
    					  children: [
									Row(
										children: [
											Expanded(
												child: Align(
													alignment: Alignment.center,
													child: GestureDetector(
														child: Container(
															margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
															child: Text(
																'Актуальне',
																style: build_account_screen.timerBoldStyle,
															),
														),
														onTap: () {
															setState(() {
																widget.app_service.account_actual_events = true;
															});
														},
													),
												),
											),

											Expanded(
												child: Align(
													alignment: Alignment.center,
													child: GestureDetector(
														child: Container(
															margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
															child: Text(
																'Історія',
																style: build_account_screen.timerBoldStyle,
															),
														),
														onTap: () {
															setState(() {
																widget.app_service.account_actual_events = false;
															});
														},
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
    					    				child: widget.app_service.account_actual_events ? ActiveDivider() : InactiveDivider(),
    					    			),
    					    		),

    					    		Expanded(
    					    			child: Padding(
    					    				padding: const EdgeInsets.fromLTRB(0, 13, 15, 0),
    					    				child: widget.app_service.account_actual_events ? InactiveDivider() : ActiveDivider(),
    					    			),
    					    		),
    					    	],
    					    ),
									Container(
									  child: widget.app_service.account_actual_events ?
									  		EventListScreen(
													event_query: widget.app_service.role==Roles.organizer ? 'created' : 'subscribed',
													is_listview: false,
												) :
												// Container()
									  		EventListScreen(
													event_query: widget.app_service.role==Roles.organizer ? 'finished' : 'attended',
													is_listview: false,
												),
									),
    					  ],
    					),

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