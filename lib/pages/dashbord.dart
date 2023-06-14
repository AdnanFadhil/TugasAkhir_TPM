import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/book_screens/loading_screen.dart';
import 'package:tugas_akhir/pages/converter_page.dart';
import 'package:tugas_akhir/pages/date_converter_page.dart';
import 'package:tugas_akhir/pages/loginPage.dart';
import 'package:tugas_akhir/pages/about_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String username = '';

  @override
  void initState() {
    super.initState();
    checkToken();
    getUsername();
  }

  void checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current time
    var now = DateTime.now();

    // Determine the greeting based on the current hour
    var greeting = '';
    if (now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.grey, // Add your desired color
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              'Hello, $username!',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hello, $username!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    '$greeting',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://play-lh.googleusercontent.com/rLrlAiTrYG-ZbW3B1ISt5nlSeejzG5VkQ5NmAVf_shDCB3eKVMWNZDZzX8CCG-_VFryo'),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          var l = ["mystery", "fantasy", "horror", "romance"];
                          return loadingscreen(l: l);
                        }),
                      );
                    },
                    child: Container(
                      color: Colors.grey,
                      child: itemDashboard(
                        'Book',
                        CupertinoIcons.book,
                        Colors.deepOrange,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurrencyConverterPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Currency Convert',
                      CupertinoIcons.money_dollar,
                      Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KonversiWaktuPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Date Converter',
                      CupertinoIcons.calendar,
                      Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'About',
                      CupertinoIcons.info,
                      Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    child: itemDashboard(
                      'LogOut',
                      CupertinoIcons.arrow_right,
                      Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
