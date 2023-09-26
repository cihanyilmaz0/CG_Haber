import 'package:cloud_firestore/cloud_firestore.dart';

class PostMessage {
  Future<bool> checkAndRetrieveData(String docID) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Messages')
        .where('docID', isEqualTo: docID)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void postMessage(bool data,String docID,String yollayan,String alan,String message) async{
    if(message.isNotEmpty){
      if(data){
        await FirebaseFirestore.instance.collection('Messages').doc(docID).collection('message').add(
            {
              'message':message,
              'sendBy':yollayan,
              'sendTo':alan,
              'time':DateTime.now(),
              'isRead':false
            }
        );
      }else{
        await FirebaseFirestore.instance.collection('Messages').doc(docID).set(
            {
              'users':[yollayan,alan],
              'docID': docID
            }
        );
        await FirebaseFirestore.instance.collection('Messages').doc(docID).collection('message').add(
            {
              'message':message,
              'sendBy':yollayan,
              'sendTo':alan,
              'time':DateTime.now(),
              'isRead':false
            }
        );
      }
    }
  }
}