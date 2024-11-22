import 'package:aiyo11/widget/linechart_page.dart';
import 'package:aiyo11/widget/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  // 支持的電子郵件和電話號碼
  final String supportEmail = 'ntueaiyo@gmail.com';
  final String supportPhone = '+1234567890';

  // 打開電子郵件應用的方法
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query:
          'subject=${Uri.encodeComponent("需要幫助")}&body=${Uri.encodeComponent("請描述您的問題...")}',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw '無法打開電子郵件應用';
    }
  }

  // 打開電話應用的方法
  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: supportPhone,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw '無法撥打電話';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6563A5),
        iconTheme: IconThemeData(
          color: Colors.white, // 改變返回箭頭的顏色為白色
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 25),
                  Icon(
                    Icons.help,
                    size: 60,
                    color: CustomColors.kPrimaryColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '需要幫助嗎？我們隨時為您提供支持！',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.kPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _launchEmail,
                    icon: Icon(Icons.email),
                    label: Text('通過電子郵件聯繫我們'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 25), // 正確的位置
                  ElevatedButton.icon(
                    icon: Icon(Icons.phone),
                    label: Text('撥打客服電話'),
                    onPressed: _launchPhone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 55,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
