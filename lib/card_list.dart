import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class card_list extends StatelessWidget {
	const card_list({super.key});
	static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
	static const TextStyle timerStyle = TextStyle(fontSize: 18,);

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Container(
				margin: EdgeInsets.all(10),
			  child: ClipRRect(
			  	borderRadius: BorderRadius.circular(20.0),

			  	child: ConstrainedBox(
					constraints: const BoxConstraints(
						minWidth: 70,
						minHeight: 80,
						maxWidth: double.infinity,
						maxHeight: 450,
					),
			  	  child: Column(

			  	  	children: [
						Flexible(
							flex: 10,
							child: Image.asset(
			  	  		  	'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
			  	  		  	fit: BoxFit.fitWidth,
			  	  		  ),
			  	  		),
						Flexible(
							flex: 8,

			  	  		    child: Container(
			  	  		    	child: Column(
			  	  		    		children: [
									Container(
										margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
			  	  		    				child: Text('TedX UA про волонтерство', style: optionStyle,),
			  	  		    			),
			  	  		    			Spacer(),
									Container(
										margin: const EdgeInsets.fromLTRB(20, 0, 8, 12),
			  	  		    				child: Row(
			  	  		    					children: [
			  	  		    						Icon(Icons.access_time),
			  	  		    						Padding(
			  	  		    							padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
			  	  		    							child: Text('Постійна зайнятість', style: timerStyle,),
			  	  		    						),
			  	  		    					],
			  	  		    				),
			  	  		    			),
			  	  		    			// Spacer(),
			  	  		    			Container(
			  	  		    				margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
			  	  		    				child: Row(
			  	  		    					children: [
			  	  		    						Icon(Icons.location_on),
			  	  		    						Padding(
			  	  		    							padding: const EdgeInsets.symmetric(horizontal: 8.0),
			  	  		    							child: Text('Вул. Валова, 27', style: timerStyle,),
			  	  		    						),
			  	  		    					],
			  	  		    				),
			  	  		    			),
			  	  		    		],
			  	  		    	),
			  	  		    ),
			  	  		  ),
			  	  	]),
			  	),
			  ),
			),
		);
	}
}

