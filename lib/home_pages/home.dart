import 'package:aiyo11/home_pages/achievement.dart';
import 'package:flutter/material.dart';
import 'fit_page.dart';
import 'package:intl/intl.dart'; // 引入 intl 包以格式化日期
import 'package:aiyo11/home_pages/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiyo11/component/yoga_pose.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchText = "";
  List<YogaPose> favoritePoses = [];
  bool showFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadFavoritePoses();
  }

  // 獲取當前日期
  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(now);
  }

  // 獲取最愛瑜伽姿勢
  Future<void> _loadFavoritePoses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<YogaPose> favorites = [];
    for (var pose in yogaPoses) {
      if (prefs.getBool('favorite_${pose.name}') ?? false) {
        favorites.add(pose);
      }
    }
    setState(() {
      favoritePoses = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 根據 showFavorites 標誌來決定顯示的瑜伽姿勢列表
    List<YogaPose> displayedList = showFavorites ? favoritePoses : yogaPoses;

    // 根據搜尋文本過濾列表
    List<YogaPose> filteredList = displayedList
        .where((pose) =>
            pose.cname.contains(searchText) ||
            pose.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6563A5), Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Hi, User!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            getCurrentDate(), // 顯示當前日期
                            style: TextStyle(
                                color: Color(0xFFBDB5DA), fontSize: 18),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AchievementPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFBDB5DA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  SizedBox(
                    height: 60, // 設定搜尋欄的寬度
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFFBDB5DA),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Let's do YOGA!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          setState(() {
                            if (value == 'Favorite') {
                              showFavorites = true;
                              _loadFavoritePoses(); // 確保最愛瑜伽姿勢是最新的
                            } else {
                              showFavorites = false;
                            }
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'Favorite',
                              child: Text('Favorite'),
                            ),
                            PopupMenuItem<String>(
                              value: 'All',
                              child: Text('See All'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    itemCount: filteredList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.height - 50 - 25) /
                              (4 * 260),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FitPage(
                                  img: filteredList[index].imageName,
                                  yogaPose: filteredList[index],
                                ),
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFF5F3FF),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'asset/images/${filteredList[index].imageName}.png',
                                  width: 110,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                filteredList[index].cname,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              SizedBox(height: 1),
                              Text(
                                filteredList[index].name,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
