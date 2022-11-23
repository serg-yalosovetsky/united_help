import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../services/authenticate.dart';

class EmailPasswordConfirmationScreen extends StatelessWidget {
	const EmailPasswordConfirmationScreen({super.key});
	@override
	Widget build(BuildContext context) {

		const TextStyle back_style = TextStyle(color: Colors.blue, fontSize: 17);
		return MaterialApp(
		  home: Scaffold(
				appBar: AppBar(
					title: Row(
					  children: [
							Icon(Icons.arrow_back_ios),
							const Text(
								'Назад',
								style: back_style,
							),
							Expanded(
							  child: Padding(
							  	padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
							  	child: const Text(
							  		'Вхід',
										style: TextStyle(color: Colors.black),
										textAlign: TextAlign.center,
							  	),
							  ),
							),

							Icon(Icons.arrow_back_ios, color: Colors.white),
							const Text(
								'Назад',
								style: TextStyle(color: Colors.white),
							),

					  ],
					),
					backgroundColor: Colors.white,
					foregroundColor: Colors.blue,
				),
		  	backgroundColor: ColorConstant.whiteA700,
		  	body: SafeArea(
		  	  child: Container(
		  	  	// width: size.width,
		  	  	child: SingleChildScrollView(
		  	  		child: Center(
		  	  		  child: Column(
		  	  		  	// mainAxisSize: MainAxisSize.min,
		  	  		  	crossAxisAlignment: CrossAxisAlignment.center,
		  	  		  	mainAxisAlignment: MainAxisAlignment.center,
		  	  		  	children: [
		  	  		  		Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 147, 64, 0),
		  	  		  			child: Image.asset(
													'images/img_1.png',
													height: 184.00,
		  	  		  			),
		  	  		  		),
										Padding(
											padding: EdgeInsets.fromLTRB(64, 20, 64, 0),
											child: Text(
												"Ми надіслали Email",
												overflow: TextOverflow.ellipsis,
												textAlign: TextAlign.left,
												style: TextStyle(
													color: ColorConstant.bluegray900,
													fontSize:22,
													fontFamily: 'SF Pro Text',
													fontWeight: FontWeight.w600,
													height: 1.00,
												),
											),
										),
										Container(
											width: 222.00,
											margin: EdgeInsets.fromLTRB(77, 3, 77, 0),
											child: Text(
												"Будь ласка, підтвердіть зміну пароля в Email",
												maxLines: null,
												textAlign: TextAlign.center,
												style: TextStyle(
													color: ColorConstant.bluegray200,
													fontSize: 17,
													fontFamily: 'SF Pro Text',
													fontWeight: FontWeight.w500,
													height: 1.25,
												),
											),
										),

									],
		  	  		  ),
		  	  		),
		  	  	),
		  	  ),
		  	),
		  ),
		);
	}
}

class welcome_button extends StatelessWidget {
  const welcome_button({
    Key? key,
	  required this.text_style,
	  required this.text,
	  required this.padding,
		this.fun,
  }) : super(key: key);

  final TextStyle text_style;
	final String text;
	final VoidCallback? fun;
  final List<double> padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding[0], padding[1], padding[2], padding[3]),
      child: SizedBox(
		  height: 44,
			width: 230,
        child: ElevatedButton(
          style: ButtonStyle(
    		  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    		  RoundedRectangleBorder(
    				borderRadius: BorderRadius.circular(22.0),
    				// side: BorderSide(color: Colors.red)
    				),
    		  ),
    	),
          onPressed: fun,
          child: Text(
      	  	text,
      	  	style: text_style,
      	  ),
        ),
      ),
    );
  }
}
