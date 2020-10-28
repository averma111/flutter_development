import 'package:brew_coffee/models/user.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:brew_coffee/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_coffee/shared/contants.dart';
import 'package:provider/provider.dart';

class Settingsform extends StatefulWidget {
  @override
  _SettingsformState createState() => _SettingsformState();
}

class _SettingsformState extends State<Settingsform> {
  final _formkey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return StreamBuilder < Userdata > (
        stream: Databaseservie(uid: user.uid).userData,
    builder: (context, snaphost) {
    if (snaphost.hasData) {
    Userdata userdata = snaphost.data;
    return Form(
    key: _formkey,
    child: Column(
    children: <Widget>[
    Text('Update your brew settings',
    style: TextStyle(fontSize: 18.0)),
    SizedBox(height: 20.0),
    TextFormField(
    initialValue: userdata.name,
    decoration: textInputDeclaration,
    validator: (val) =>
    val.isEmpty ? 'Please enter the name' : null,
    onChanged: (val) => setState(() => _currentName = val),
    ),
    SizedBox(height: 20.0),
    DropdownButtonFormField(
    decoration: textInputDeclaration,
    value: _currentSugar ?? userdata.sugars,
    items: sugars.map((sugar) {
    return DropdownMenuItem(
    value: sugar,
    child: Text('$sugar sugars'),
    );
    }).toList(),
    onChanged: (val) => setState(() => _currentSugar = val),
    ),
    Slider(
    value: (_currentStrength ?? userdata.strength).toDouble(),
    activeColor: Colors.brown[_currentStrength ?? userdata.strength],
    inactiveColor: Colors.brown[_currentStrength ?? userdata.strength],
    min: 100.0,
    max: 900.0,
    divisions: 8,
    onChanged: (val) =>
    setState(() => _currentStrength = val.round()),
    ),
    RaisedButton(
    color: Colors.deepOrange,
    child: Text(
    'Update',
    style: TextStyle(color: Colors.brown[100]),
    ),
    onPressed: () async {
      if (_formkey.currentState.validate()) {
        await Databaseservie(uid: user.uid).updateUserDate(
            _currentSugar ?? userdata.sugars,
            _currentName ?? userdata.name,
            _currentStrength ?? userdata.strength
        );
        Navigator.pop(context);
      }
    }
    )
    ]
      ,
    ),
    );
    } else {
    return Loading();
    }
    });
    }
  }
