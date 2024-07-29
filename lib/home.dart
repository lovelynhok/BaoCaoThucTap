import 'package:flutter/material.dart';
import 'package:untitled1/addnew.dart';
import 'package:untitled1/effi.dart';
import 'package:untitled1/AttendanceScreen.dart';
import 'package:untitled1/managermoney.dart';
import 'package:untitled1/salary.dart';
import 'employee_list_page.dart';
import 'timesheet_list_page.dart';
import 'asset_list_screen.dart';
import 'list_salary_page.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  HomeScreen({required this.userEmail});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _tabs.add(HomeTab(userEmail: widget.userEmail));
    _tabs.add(ProfileTab(userEmail: widget.userEmail));
    _tabs.add(SettingsTab());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Xử lý khi nhấn vào nút thông báo
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Xử lý khi nhấn vào nút cài đặt
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Xử lý khi nhấn vào nút đăng xuất
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String userEmail;

  HomeTab({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            SmallCard(
              icon: Icons.people,
              title: 'Danh sách \nnhân viên',
              color: Colors.teal,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
                print('Đã nhấn vào thẻ Danh sách nhân viên');
              },
            ),
            SmallCard(
              icon: Icons.add_a_photo,
              title: 'Thêm nhân viên',
              color: Colors.blue,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
                print('Đã nhấn vào thẻ Thêm nhân viên');
              },
            ),
            SmallCard(
              icon: Icons.money,
              title: 'Quản lí tài sản',
              color: Colors.blue,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssetListPage()),
                );
                print('Đã nhấn vào thẻ Quản lí tài sản');
              },
            ),
            SmallCard(
              icon: Icons.trending_up,
              title: 'Hiệu Suất',
              color: Colors.orange,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Manager()),
                );
                print('Đã nhấn vào thẻ Hiệu Suất');
              },
            ),
            SmallCard(
              icon: Icons.calendar_month,
              title: 'Chấm công',
              color: Colors.purple,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimesheetListPage()),
                );
                print('Đã nhấn vào thẻ Chấm công');
              },
            ),
            SmallCard(
              icon: Icons.insert_chart,
              title: 'Quản lí lương',
              color: Colors.purple,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalaryListPage()),
                );
                print('Đã nhấn vào thẻ Quản lí lương');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPress;

  SmallCard({required this.icon, required this.title, required this.color, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final String userEmail;

  ProfileTab({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile: $userEmail',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
