import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:getx_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:getx_firebase/app/modules/notes_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotes(NotesModel model) async {
    var options = SetOptions(merge: true);

    await _firestore
        .collection("notes")
        .doc(model.notesId)
        .set(model.toMap(), options)
        .then((value) => print("Notes Added"))
        .catchError((error) => print("Failed to add Notes: $error"));

    Get.find<AuthController>().clearf();
  }

  Stream<List<NotesModel>> getNotesList() {
    return _firestore.collection("notes").snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NotesModel.fromJson(doc.data())).toList());
  }

  Future<void> getSinglenote(String id) async {
    var document = await _firestore.collection("notes").doc(id).snapshots();
    print(document);
    print('++++++++++++++++++');
    print(document.toString);
  }

  Future<void> updateNotes(NotesModel model) async {
    //  _firestore.collection("notes").doc(nid).update()
    //  var options = SetOptions(merge: true);

    await _firestore
        .collection("notes")
        .doc(model.notesId)
        .update(model.toMap())
        .then((value) => print("Notes updated"))
        .catchError((error) => print("Failed to add Notes: $error"));
            Get.find<AuthController>().clearf();

  }

  //Delete
  Future<void> removeNOtes(String nId) {
    return _firestore
        .collection('notes')
        .doc(nId)
        .delete()
        .then((value) => print("delete notes"))
        .catchError((err) => print("Failed $err"));
  }
}
