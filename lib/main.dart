import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(20),
        child: Column(

          children: [
            Image.asset(
              'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
              // width: 300,
              // height: 100,
            ),
            SizedBox(
            height: 100,
            child: Center(child: Text('TedX UA про волонтерство', style: optionStyle,)),
          ),
        ]),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const bottom_selected_tab_color = Color.fromRGBO(0, 113, 216, 1);
  static const bottom_unselected_tab_color = Color.fromRGBO(142, 142, 147, 1);

  static const home_label = 'Головна';
  static const event_label = 'Мої івенти';
  static const notify_label = 'Сповіщення';
  static const accaunt_label = 'Аккаунт';
  List<bool> isSelected = [true, false];


  static const childrens =  [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('Актуальне', style: TextStyle(fontSize: 18)),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('На мапі', style: TextStyle(fontSize: 18)),
    ),
  ];




  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<bool> isSelected = [true, false];

    ToggleButtons toggle_button = ToggleButtons(
      // list of booleans
        isSelected: isSelected,
        // text color of selected toggle
        selectedColor: Colors.black,
        disabledColor: Colors.black,
        // text color of not selected toggle
        color: Colors.grey,
        // fill color of selected toggle
        fillColor: Colors.white,
        // when pressed, splash color is seen
        // splashColor: Colors.red,
        // long press to identify highlight color
        highlightColor: Colors.blue,
        // if consistency is needed for all text style
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        // border properties for each toggle
        renderBorder: true,
        borderColor: Colors.white,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(10),
        selectedBorderColor: Colors.grey,
        // add widgets for which the users need to toggle
        children: childrens,
        // to select or deselect when pressed
        onPressed: (int newIndex) {
          setState( () {
            isSelected[0] = !isSelected[0];
            isSelected[1] = !isSelected[1];
          });
        }
    );

    List<Widget> _widgetOptions = <Widget>[
      ListView(
        children: <Widget>[
          Spacer(),
          Center(
            child: toggle_button
          ),
          Spacer(),
          OutlinedCardExample(),
          Spacer(),
          OutlinedCardExample(),
          Spacer(),
          OutlinedCardExample(),
          Spacer(),
        ],
      ),
      Text(
        event_label,
        style: optionStyle,
      ),
      Text(
        notify_label,
        style: optionStyle,
      ),
      Text(
        accaunt_label,
        style: optionStyle,
      ),
    ];
    Widget card = Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Outlined Card')),
        ),
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: home_label,
            // backgroundColor: bottom_tab_color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: event_label,
            // backgroundColor: bottom_tab_color,

            // backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: notify_label,
            // backgroundColor: bottom_tab_color,
            // backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: accaunt_label,
            // backgroundColor: bottom_tab_color,

            // backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: bottom_selected_tab_color,
        unselectedItemColor: bottom_unselected_tab_color,
        onTap: _onItemTapped,
      ),
    );
  }
}
