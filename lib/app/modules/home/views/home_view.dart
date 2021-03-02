import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:getx_firebase/app/modules/notes_model.dart';
import 'package:getx_firebase/app/services/database.dart';
import 'package:getx_firebase/app/widget/card.dart';
import 'package:image_picker/image_picker.dart';

AuthController controller = Get.find(); // it'll work!

class HomeView extends StatelessWidget {
  FirestoreService service;
  NotesModel notesModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child:  TextField(
                controller: controller.searchController,
                decoration:
                    InputDecoration(labelText: 'Search', hintText: 'Search..'),
                onChanged: (value) {
                  value = value.toLowerCase();
                  controller.notes.where((note) {
                    var n = note.title.toLowerCase();
                    print(n);
                    print('+++++++++++++++++++++++++++++++++++++++++++++++');
                    return n.contains(value);
                  });
                },
              ),
            
          ),
          Obx(() => Expanded(
                child: ListView.builder(
                  itemCount: controller.notes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onLongPress: () {
                            Get.defaultDialog(
                                title: 'Choose Action',
                                content: Column(
                                  children: [
                                    FlatButton(
                                      onPressed: () {
                                        print('delete item');
                                        deleteItem(
                                            controller.notes[index].notesId);
                                        Get.back();
                                      },
                                      child: Text(
                                        'DELETE',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Get.to(TodoCard(
                                            todo: controller.notes[index]));
                                        // updateNote(controller.notes[index].notesId);
                                      },
                                      child: Text(
                                        'EDIT',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        print('delete item');
                                        shareData(controller.notes[index].title);
                                        // Get.back();
                                      },
                                      child: Text(
                                        'SHARE',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          title: Text(controller.notes[index].title != null
                              ? controller.notes[index].title
                              : 'g'),
                          subtitle: Text(controller.notes[index].desc) ?? '',
                          leading: CircleAvatar(
                            backgroundColor: Colors.amberAccent,
                            child: Text(
                                controller.notes[index].title[0].capitalize),
                          ),
                          trailing: Container(
                            height: 50,
                            width: 50,
                            child:
                                Image.file(File(controller.notes[index].image)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.bottomSheet(
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                  ),
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Add Note',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                        SizedBox(height: 10),
                        TextField(
                            controller: controller.titleController,
                            decoration: InputDecoration(labelText: 'Title')),
                        SizedBox(height: 10),
                        TextField(
                            controller: controller.descController,
                            decoration:
                                InputDecoration(labelText: 'Description')),
                        SizedBox(height: 10),
                        Obx(() => controller.selectedImagePath.value == ''
                            ? Text('')
                            : Image.file(
                                File(controller.selectedImagePath.value),
                                height: 100,
                                width: 100,
                              )),
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
                        SizedBox(
                          height: 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                if (controller.titleController.value != null) {
                                  var title = controller.titleController.value;
                                  var desc = controller.descController.value;
                                  var data = NotesModel(
                                      title: title.text,
                                      desc: desc.text,
                                      image: controller.selectedImagePath.value,
                                      notesId: controller.uuid.v1());

                                  addNote(data);
                                } else {
                                  Get.snackbar('Error', 'Please write notes');
                                }
                              },
                              child: Text('Save'),
                            ),
                            RaisedButton(
                              color: Colors.green,
                              onPressed: () => Get.back(),
                              child: Text('Cancel'),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            );
          }),
    );
  }

  void addNote(NotesModel model) async {
    print(model.toString());
    await FirestoreService().addNotes(model);
    controller.descController.text = '';
    controller.titleController.text = '';
  }

  void deleteItem(String id) async {
    await FirestoreService().removeNOtes(id);
  }

  void shareData(String title) async {
    await controller.share(title);
  }

  // void updateNote(String id) async {
  //   await FirestoreService().updateNotes(id);
  // }
}
