import 'package:brew_coffee/models/brew.dart';
import 'package:brew_coffee/screens/home/brew_list.dart';
import 'package:brew_coffee/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:brew_coffee/services/auth.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Authservice _auth = Authservice();
  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: Settingsform(),
        );
      });
    }
    return StreamProvider<List<Brew>>.value(
      value: Databaseservie().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Coffee'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Logout'),
                onPressed: () async {
                  await _auth.signOut();
                }),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('setting'),
              onPressed: () => _showSettingsPanel()
            )
          ],
        ),
        body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover
            )
          ),
          child:Brewlist(

          )
          ),
      ),
    );
  }
}
