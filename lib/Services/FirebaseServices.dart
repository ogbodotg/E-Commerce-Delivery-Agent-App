import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference deliveryAgents =
      FirebaseFirestore.instance.collection('AhiaDelivery');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  CollectionReference ahiaUsers =
      FirebaseFirestore.instance.collection('Ahia Users');

  Future<DocumentSnapshot> validateUser(id) async {
    DocumentSnapshot result = await deliveryAgents.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await ahiaUsers.doc(id).get();
    return doc;
  }

  Future<void> updateStatus({id, status}) {
    return orders.doc(id).update({
      'orderStatus': status,
    });
  }
}
