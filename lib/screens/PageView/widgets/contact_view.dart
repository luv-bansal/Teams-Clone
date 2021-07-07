import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';

class ContactView extends StatefulWidget {
  const ContactView({ Key? key }) : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Luv Bansal",
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
      subtitle: Text(
        "Hello",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onlineDotColor,
                    border: Border.all(color: blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}