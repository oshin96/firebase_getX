import 'package:flutter/material.dart';

class NotesModel {
  String notesId;
  String title;
  String desc;
  String image;

  NotesModel({this.title, this.desc, this.image, @required this.notesId});

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
        title: json['title'],
        desc: json['desc'],
        image: json['image'],
        notesId: json['notesId']);
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'desc': desc, 'image': image, 'notesId': notesId};
  }
}
