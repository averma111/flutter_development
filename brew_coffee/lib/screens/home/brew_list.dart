import 'package:brew_coffee/models/brew.dart';
import 'package:brew_coffee/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Brewlist extends StatefulWidget {
  @override
  _BrewlistState createState() => _BrewlistState();
}

class _BrewlistState extends State<Brewlist> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>>(context) ?? [];

    if (brews.length != null) {
      return ListView.builder(
        itemCount: brews.length,
        itemBuilder: (context, index) {
          return Brewtile(brew: brews[index]);
        },
      );
    }
  }
}
