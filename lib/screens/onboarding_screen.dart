import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:teams_clone/screens/wrapper.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [

        // On-board screen page 1
        PageViewModel(
          title: 'Create a Meetings and connect with others virtualy',
          body:
              'Share the meeting code with others to allow them to enter into meeting',
          image: buildImage('assets/virtual_meeting.png', context),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.all(24),
            descriptionPadding: EdgeInsets.all(20),
            pageColor: Color(0xff19191b),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),

        // On-board screen page 2
        PageViewModel(
          title: 'Chat and video call with anyone and anywhere',
          body: '',
          image: buildImage('assets/chat_and_video_call.png', context),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.all(24),
            descriptionPadding: EdgeInsets.all(20),
            pageColor: Color(0xff19191b),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w400, fontSize: 10.0),
          ),
        ),

        // On-board screen page 3
        PageViewModel(
          title: 'Group chat and arrange meetings in teams',
          body:
              'Team participants can share info without disrupting the flow of the meeting. ',
          image: buildImage('assets/teams.jpg', context),
          footer: GestureDetector(
            onTap: () async {
              await _storeOnboardInfo();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Wrapper();
              }));
            },
            child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.indigo),
                child: Center(
                    child: Text(
                  "Let's go",
                  style: TextStyle(fontSize: 23),
                ))),
          ),
          decoration: const PageDecoration(
            descriptionPadding: EdgeInsets.all(20),
            imagePadding: EdgeInsets.all(20),
            pageColor: Color(0xff19191b),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
      ],
      done: const Text("Let's Go",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      showSkipButton: true,
      skip: Container(
          width: 75,
          height: 28,
          // width: MediaQuery.of(context).size.width*0.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.indigo[500]),
          child: Center(
            child: Text(
              "skip",
              style: TextStyle(color: whiteColor),
            ),
          )),
      showNextButton: false,
      onDone: () async {
        await _storeOnboardInfo();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Wrapper();
        }));
      },
    );
  }

onBoardScreenPage1() {
    PageViewModel(
      title: 'Create a Meetings and connect with others virtualy',
      body:
          'Share the meeting code with others to allow them to enter into meeting',
      image: buildImage('assets/virtual_meeting.png', context),
      decoration: PageDecoration(
        imagePadding: EdgeInsets.all(24),
        descriptionPadding: EdgeInsets.all(20),
        pageColor: Color(0xff19191b),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
      ),
    );
  }



  Widget buildImage(String path, context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(19),
        child: new Image.asset(
          path,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}


