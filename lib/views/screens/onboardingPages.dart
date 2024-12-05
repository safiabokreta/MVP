import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: controller,
            children: [
              // Page 1
              Container(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/startingPage1.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 50,
                      right: 50,
                      bottom: 130,
                      child: Text(
                        '''Your dream day starts here.\nFind the perfect venue,\n tailored to your vision.''',
                        style: GoogleFonts.raleway(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Page 2
              Container(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/startingPage2.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 30,
                      right: 30,
                      bottom: 130,
                      child: Text(
                        '''Create the ultimate celebration with\nhandpicked DJs, photographers, and\nchefs.''',
                        style: GoogleFonts.raleway(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Page 3
              Container(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/startingPage3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 130,
                      child: Text(
                        '''Enjoy every moment.\nWe’ll help you find everything you need\nfor the big day.''',
                        style: GoogleFonts.raleway(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      left: 25,
                      right: 25,
                      bottom: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 235, 118, 157),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: const Text(
                          "GET STARTED",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SmoothPageIndicator Overlay
          Positioned(
            bottom: 20, // Adjust the position
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: const Color.fromARGB(255, 235, 118, 157),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
