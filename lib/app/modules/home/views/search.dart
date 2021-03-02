import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:getx_firebase/app/modules/home/views/home_view.dart';
import 'package:getx_firebase/app/modules/notes_model.dart';
import 'package:getx_firebase/app/services/database.dart';

class NameSearch extends SearchDelegate<NotesModel> {
  // final List<String> names;
  NotesModel result;

  NameSearch(result);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = controller.notes.where((name) {
      return name.title.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestions.elementAt(index).title),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(suggestions.elementAt(index).title[0].toUpperCase()),
          ),
          onTap: () {
            result = suggestions.elementAt(index);
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = controller.notes.where((name) {
      return name.title.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            suggestions.elementAt(index).title,
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(suggestions.elementAt(index).title[0].toUpperCase()),
          ),
          onTap: () {
            query = suggestions.elementAt(index).title;
          },
        );
      },
    );
  }
}
