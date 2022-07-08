import 'package:cloud_firestore/cloud_firestore.dart';

/// A bridget for interaction with user data services.
class UserService {
  final _usersCollection = 'users';
  final _ordersCollection = 'orders';
  FirebaseFirestore _firestore;

  UserService({FirebaseFirestore firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
  }

  /// Checks if user already has a profile on database.
  Future<bool> userHasProfile(String uid) async {
    var docSnapshot =
        await _firestore.collection(_usersCollection).doc(uid).get();
    return docSnapshot.exists;
  }

  /// Creates new user profile on database with `profile` data.
  Future<void> createUserProfile(
      String uid, Map<String, dynamic> profile) async {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .set(profile);
  }

  /// Updates user profile on database with `profile` data.
  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> profile) async {
    return await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .update(profile);
  }

  /// Gets a `Stream` of user profile.
  Stream<DocumentSnapshot> getUserProfile(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots();
  }

  /// Gets a `Stream` of user order.
  Stream<DocumentSnapshot> getUserOrder(String uid, String orderId) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .collection(_ordersCollection)
        .doc(orderId)
        .snapshots();
  }

  /// Gets a `Stream` of all user orders.
  Stream<QuerySnapshot> getAllUserOrders(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .collection(_ordersCollection)
        .snapshots();
  }
}
