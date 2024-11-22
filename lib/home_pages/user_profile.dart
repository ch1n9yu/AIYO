import 'dart:io';
import 'package:aiyo11/home_pages/achievement.dart';
import 'package:aiyo11/home_pages/contact_support.dart';
import 'package:aiyo11/home_pages/settings.dart';
import 'package:aiyo11/login_pages/welcome_page.dart';
import 'package:aiyo11/services/account.dart';
import 'package:aiyo11/widget/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiyo11/home_pages/profile_page.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    XFile userPhoto =
        await accountServices.getUserPhoto(XFile('asset/images/user.png'));
    setState(() {
      _image = userPhoto;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('user_image');
      if (_imagePath != null) {
        _image = XFile(_imagePath!);
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_image', image.path);
        setState(() {
          _image = image;
        });
        await accountServices.uploadUserPhoto(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('圖片選擇失敗：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFBDB5DA), // 设置背景颜色
        child: Padding(
          padding: const EdgeInsets.only(top: 100), // 设置顶部的额外空间
          child: Column(
            children: [
              SizedBox(
                height: 120, // 调整整体大小
                width: 120, // 调整整体大小
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child: _image == null
                          ? Image.asset(
                              "asset/images/user.png",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // 设置背景颜色，使按钮边缘一致
                        ),
                        child: FloatingActionButton(
                          onPressed: _pickImage, // 选择图片
                          backgroundColor: Colors.white, // 设置按钮背景颜色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF6563A5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      email: accountServices.email!,
                                    )));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text("My Account")),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Alarm()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.notifications),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text("Notification")),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AchievementPage()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.military_tech),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text("Achievement")),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text("Settings")),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactSupportPage()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.help),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text("Help Center")),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 5),
                    child: TextButton(
                      onPressed: () {
                        accountServices.logOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF6563A5), // 设置背景颜色
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20), // 设置内边距
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 设置圆角
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white, // 设置图标颜色为白色
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              "Log out",
                              style: TextStyle(
                                color: Colors.white, // 设置文字颜色为白色
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
