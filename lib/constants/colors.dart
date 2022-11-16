import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
	static Color lightBlue300 = fromHex('#5ac8fa');

	static Color lightBlue700 = fromHex('#0071d8');

	static Color red500 = fromHex('#ff3b30');

	static Color teal9002b = fromHex('#2b022546');

	static Color gray50 = fromHex('#f6f8ff');

	static Color yellowA400 = fromHex('#fae100');

	static Color black900 = fromHex('#000000');

	static Color gray9000a = fromHex('#0a1a1a1a');

	static Color black901 = fromHex('#080808');

	static Color lightBlueA700 = fromHex('#007aff');

	static Color teal90014 = fromHex('#14022546');

	static Color black90026 = fromHex('#26000000');

	static Color black9004c = fromHex('#4c000000');

	static Color gray600 = fromHex('#7c7c7c');

	static Color gray50Ef = fromHex('#eff9f9f9');

	static Color black9000a = fromHex('#0a000000');

	static Color gray301 = fromHex('#d7e2ec');

	static Color gray400 = fromHex('#c6c6c8');

	static Color whiteA7006d = fromHex('#6dffffff');

	static Color blue500 = fromHex('#1485fd');

	static Color blue59 = fromHex('#e3ecfb');

	static Color bluegray100 = fromHex('#c6d3df');

	static Color blue55 = fromHex('#e9f5ff');

	static Color gray80099 = fromHex('#993c3c43');

	static Color gray101 = fromHex('#f0f6ff');

	static Color gray300 = fromHex('#d7e2eb');

	static Color blue50 = fromHex('#e3ecfa');

	static Color blue51 = fromHex('#dae7ff');

	static Color gray100 = fromHex('#f0f3ff');

	static Color bluegray900 = fromHex('#002140');

	static Color blue60 = fromHex('#dfeafd');

	static Color indigo100 = fromHex('#bdd2e4');

	static Color indigo101 = fromHex('#bdd1e4');

	static Color indigoA200A2 = fromHex('#a2446bf2');

	static Color bluegray500 = fromHex('#547ea5');

	static Color bluegray401 = fromHex('#748a9f');

	static Color bluegray400 = fromHex('#8e8e93');

	static Color bluegray201 = fromHex('#acbdcc');

	static Color bluegray300 = fromHex('#8ba3b8');

	static Color bluegray200 = fromHex('#adbbc7');

	static Color black90019 = fromHex('#19000000');

	static Color whiteA700 = fromHex('#ffffff');

	static Color bluegray901 = fromHex('#333333');

	static Color fromHex(String hexString) {
		final buffer = StringBuffer();
		if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
		buffer.write(hexString.replaceFirst('#', ''));
		return Color(int.parse(buffer.toString(), radix: 16));
	}
}
