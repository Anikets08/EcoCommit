import 'package:ecocommit/screens/navbar/dashboard.dart';
import 'package:ecocommit/screens/navbar/feed.dart';
import 'package:ecocommit/screens/navbar/profile.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [
    const FeedScreen(),
    const PersonalDashboard(),
    const CommunityDashboard(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: CustomColors.kGreen,
        elevation: 0,
        unselectedItemColor: CustomColors.kDark,
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.feed, semanticLabel: "feed"),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.medal, semanticLabel: "Leaderboard"),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.trophy, semanticLabel: "Leaderboard"),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user, semanticLabel: "Profile"),
            label: "",
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
