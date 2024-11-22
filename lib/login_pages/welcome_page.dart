import 'package:flutter/material.dart';
import 'package:aiyo11/login_pages/login_page.dart';
import 'package:aiyo11/login_pages/signup_page.dart';
import 'package:aiyo11/home_pages/home_bottom_bar.dart'; // Make sure you import the HomePage

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top section with image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
            ),
            child: Center(
              child: Image.asset(
                'asset/images/aiyo.png',
                scale: 0.8,
              ),
            ),
          ),
          // Bottom section with buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                color: Color(0xFF6563A5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Let's Do YOGA with AIYO!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFbdb5da),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Login button
                      Material(
                        color: Color(0xFFbdb5da),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Sign Up button
                      Material(
                        color: Color(0xFF7da5bc),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Start button
                  Material(
                    color: Color(0xFF6563A5),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeBottomBar(), // Ensure HomePage() is properly imported
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        child: Text(
                          'Quickly Start',
                          style: TextStyle(
                            color: Color(0xFFbdb5da),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
