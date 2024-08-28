import 'package:flutter/material.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/main_page/sub_page/debt_screen.dart';
import 'package:flutter_project_august/page/main_page/sub_page/home_screen.dart';
import 'package:flutter_project_august/page/main_page/sub_page/manage_screen.dart';
import 'package:flutter_project_august/page/main_page/sub_page/profile_screen.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  User _user = AppConstants.defaultUser;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    User user = await SharedPreferencesHelper.getUserInfo();
    setState(() {
      _user = user;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == AppConstants.defaultUser) {
      return const Scaffold(
        body: Center(child: Text("Lỗi khi tải thông tin người dùng")),
      );
    }

    // Conditionally show the Management screen
    List<Widget> widgetOptions = <Widget>[
      HomeScreen(
        user: _user,
      ),
      DebtScreen(
        user: _user,
      ),
      if (_user.role == 'admin') const ManagementScreen(),
      ProfileScreen(),
    ];

    List<BottomNavigationBarItem> bottomNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'Trang chủ',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.attach_money_rounded),
        label: 'Công nợ',
      ),
      if (_user.role == 'admin')
        const BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts_rounded),
          label: 'Quản lý',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded),
        label: 'Hồ Sơ',
      ),
    ];

    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        items: bottomNavBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurface,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
