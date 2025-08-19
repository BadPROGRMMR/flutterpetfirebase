import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSvc {
  final CollectionReference? queue =
      FirebaseFirestore.instance.collection("queue");

  Future<void> addQ(
      String? oname, String? pname, String? uid, String? date) async {
    await queue!.add({
      'owner': oname,
      'petname': pname,
      'userID': uid,
      'date': date,
      'timestamp': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> showQ(String? uid) {
    return queue!.where('userID', isEqualTo: uid).snapshots();
  }

  Future<void> updateQ(String docId, String newName, String newPetname) async {
    await queue!.doc(docId).update({'owner': newName, 'petname': newPetname});
  }

  Future<void> deleteQ(String docId) async {
    await queue!.doc(docId).delete();
  }
}
