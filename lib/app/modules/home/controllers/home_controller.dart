import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_firebase/app/modules/notes_model.dart';
import 'package:getx_firebase/app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_share/flutter_share.dart';

class AuthController extends GetxController {
  var uuid = Uuid();

  Rx<List<NotesModel>> notesList = Rx<List<NotesModel>>();

  List<NotesModel> get notes => notesList.value.obs;

  ///TextEdditingcontroller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  ///for image
  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;

  @override
  void onInit() {
    super.onInit();
    notesList.bindStream(
        FirestoreService().getNotesList()); //stream coming from firebase
  }

  ///for image
  void getImage(ImageSource imagesounse) async {
    final pichedFile = await ImagePicker().getImage(source: imagesounse);
    if (pichedFile != null) {
      selectedImagePath.value = pichedFile.path;
      selectedImageSize.value =
          ((File(selectedImagePath.value)).lengthSync() / 1024 / 1024)
                  .toStringAsFixed(2) +
              "Mb";
    } else {
      Get.snackbar(
        "Error",
        'No Image selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  clearimage() {
    selectedImagePath = null;
  }

  search(String title) {
    // notesList = notes.where((note){
    //   var nottitl = note.title.toLowerCase();
    //   return nottitl.contains(title);
    // }
  }

  Future<void> share( String title) async {
    await FlutterShare.share(
        title: 'Notes App',
        text: title,
       
        chooserTitle: 'Where you want to share');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
