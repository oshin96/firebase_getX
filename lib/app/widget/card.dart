import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:getx_firebase/app/modules/home/views/home_view.dart';
import 'package:getx_firebase/app/modules/notes_model.dart';
import 'package:getx_firebase/app/services/database.dart';
import 'package:image_picker/image_picker.dart';

class TodoCard extends GetView<AuthController> {
  final NotesModel todo;
  //final NotesModel model;

  const TodoCard({Key key, this.todo}) : super(key: key);

  @override
  void initState() {
    FirestoreService().getSinglenote(todo.notesId);
    controller.titleController.text = todo.title;

    print(todo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          height: 400,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: todo.title,
                      onChanged: (value) {
                        var n = value;
                        // print(n);
                        controller.titleController.text = n;
                        print(controller.titleController.value);
                      },
                      // controller: controller.titleController,
                      decoration: InputDecoration(
                        labelText: todo.title,
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      initialValue: todo.desc,
                      onChanged: (value) {
                        var des = value;
                        // print(n);
                        controller.descController.text = des;
                        print(controller.descController.value);
                      },
                      // controller: controller.titleController,
                      decoration: InputDecoration(
                        labelText: todo.title,
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  todo.image == ''
                      ? Image.asset(
                          'images/download.jpg',
                          height: 100,
                          width: 100,
                        )
                      : Image.file(
                          File(todo.image),
                          height: 100,
                          width: 100,
                        ),
                        Align(
                          child: Text(
                            'Select Image',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          alignment: Alignment.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                barrierDismissible: true,
                                title: 'Select',
                                content: Column(
                                  children: [
                                    FlatButton(
                                      color: Colors.grey,
                                      child: Text('Camera'),
                                      onPressed: () {
                                        controller.getImage(ImageSource.camera);
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.grey,
                                      child: Text('Gallery'),
                                      onPressed: () {
                                        controller
                                            .getImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ));
                          },
                          child: Icon(Icons.camera_alt),
                        ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      var t = controller.titleController.value.text;
                      var d = controller.descController.value.text;

                      var data =
                          NotesModel(title: t, desc: d, notesId: todo.notesId);
                      FirestoreService().updateNotes(data);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
