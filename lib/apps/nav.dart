import 'package:digitalcard/apps/homePage.dart';
import 'package:digitalcard/constants.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('Second'),
    Text('Third'),
    Text('Fourth'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLightDesign() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: accent,
      strokeColor: accent,
      unSelectedColor: Colors.grey[100],
      backgroundColor: Theme.of(context).accentColor,
      items: [
        CustomNavigationBarItem(
          icon: Icons.home,
        ),
        CustomNavigationBarItem(
          icon: Icons.category,
        ),
        CustomNavigationBarItem(
          icon: Icons.subscriptions,
        ),
        CustomNavigationBarItem(icon: Icons.person),
        // CustomNavigationBarItem(
        //   icon: Icons.account_circle,
        // ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar Tutorial'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildLightDesign(),
    );
  }
}

//TODO: Offline Nav Bar
///
class OfflineNav extends StatefulWidget {
  @override
  _OfflineNavState createState() => _OfflineNavState();
}

class _OfflineNavState extends State<OfflineNav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
    Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
    Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
    Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLightDesign() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: accent,
      strokeColor: accent,
      unSelectedColor: Colors.grey[100],
      backgroundColor: Theme.of(context).accentColor,
      items: [
        CustomNavigationBarItem(
          icon: Icons.home,
        ),
        CustomNavigationBarItem(
          icon: Icons.category,
        ),
        CustomNavigationBarItem(
          icon: Icons.subscriptions,
        ),
        CustomNavigationBarItem(icon: Icons.person),
        // CustomNavigationBarItem(
        //   icon: Icons.account_circle,
        // ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ]),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
            SizedBox(
              height: 12,
            ),
            Text('Loading ...')
          ],
        )),
      ),

      //? UnComment Below for Navigation Bar
      //  Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      // bottomNavigationBar: _buildLightDesign(),
    );
  }
}
