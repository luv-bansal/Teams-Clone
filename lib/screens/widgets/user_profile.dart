import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/services/google_sign_in.dart';

class UserProfile extends StatelessWidget {
  final User user;
  UserProfile({required this.user});
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              actions: [
                FlatButton(onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context,
                          listen: false);
                      provider.logout();
                },
                 child: Text("Sign Out"))
              ],
              
            ),
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(user.photoURL ??
                  'https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(user.displayName!, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20), ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email : ', style: TextStyle(fontSize: 17),),
                  Text(user.email!, style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
                        Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone No. : ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    user.phoneNumber ?? "",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
                      
          ],
          ),
      ),
    );
  }
}