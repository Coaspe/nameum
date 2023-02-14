import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_custom/src/exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nameum_types/nameum_types.dart';

// SingleTone class
class FireStoreMethods {
  static FirebaseFirestore fs = FirebaseFirestore.instance;

  static Future<User> getUserByEmailWithSignup(
      String email, String name, String userId) async {
    CollectionReference users = fs.collection('users');
    User newUser;
    DocumentSnapshot doc = await users.doc(email).get();
    if (doc.exists) {
      newUser = User.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      newUser = await addUser(email, name, userId);
    }
    return newUser;
  }

  static Future<User?> getUserByEmail(String email) async {
    CollectionReference users = fs.collection('users');
    User? newUser;
    DocumentSnapshot doc = await users.doc(email).get();
    if (doc.exists) {
      newUser = User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return newUser;
  }

  static Future<User> addUser(String email, String name, String userId) async {
    CollectionReference users = fs.collection('users');
    User newUser =
        User(email: email, name: name, userId: userId, profileImg: "");
    users.doc(email).set(newUser.toJson());
    return newUser;
  }

  static Future<User> signUpWithoutFirebase(
      String email, String name, String password) async {
    CollectionReference users = fs.collection('users');
    bool check = (await users.doc(email).get()).exists;
    if (check) {
      throw DuplicatedEmail();
    }
    User newUser = User(
        email: email,
        name: name,
        userId: "",
        profileImg: "",
        signupType: SignupType.email,
        password: password);
    users.doc(email).set(newUser.toJson());
    return newUser;
  }

  static Future<String> addStore(Store newStoreInfo) async {
    CollectionReference stores = fs.collection('stores');
    String id = (await stores.add(newStoreInfo.toJson())).id;
    return id;
  }

  static Future<Store> getStoreInfo(String id) async {
    CollectionReference stores = fs.collection('stores');
    DocumentSnapshot doc = await stores.doc(id).get();
    Store store;
    if (doc.exists)
      store = Store.fromJson(doc.data() as Map<String, dynamic>);
    else
      store = Store(
          storeName: '등록되지 않은 가게',
          storeId: '0',
          tables: {},
          owner: "",
          address: Address());
    return store;
  }

  static Future<void> reserveStore(
      String storeId, User user, int table, String message) async {
    WriteBatch batch = fs.batch();
    int _time = DateTime.now().microsecondsSinceEpoch;
    Store store = await getStoreInfo(storeId);

    int check = 0;
    store.reserveClients.values.forEach((element) {
      if (element.table == table) check += 1;
    });
    if (check == store.tables[table]) {
      throw FullTable("$table인석에 빈자리가 없습니다.");
    }

    final Map<String, dynamic> updateStore = Map();
    final Map<String, dynamic> updateUser = Map();

    updateStore['reserve_clients.${user.userId}'] =
        ReserveInfo(time: _time, table: table, message: message).toJson();
    updateUser['reserve_store.${storeId}'] = ReserveState.pending.name;
    batch.update(fs.collection('users').doc(user.email), updateUser);
    batch.update(fs.collection('stores').doc(storeId), updateStore);
    return await batch.commit();
  }

  static Future<void> cancelReservation(String storeId, User user) async {
    final Store store = await getStoreInfo(storeId);
    if (!store.reserveClients.containsKey(user.userId)) {
      throw NoSuchReservation("해당 예약 정보가 존재하지 않습니다");
    }
    WriteBatch batch = fs.batch();
    final Map<String, dynamic> updateUser = Map();
    final Map<String, dynamic> updateStore = Map();
    updateUser['reserve_store.$storeId'] = FieldValue.delete();
    updateStore['reserve_clients.${user.userId}'] = FieldValue.delete();
    batch.update(fs.collection('users').doc(user.email), updateUser);
    batch.update(fs.collection('stores').doc(storeId), updateStore);
    return await batch.commit();
  }

  static Future<List<Store>> getAllStores() async {
    CollectionReference stores = fs.collection('stores');
    QuerySnapshot<Object?> snapshots = await stores.get();
    List<Store> allStores =
        snapshots.docs.map((e) => Store.fromJson(e.data() as dynamic)).toList();
    return allStores;
  }

  static Future<List<Store>> getListStores(List<String> storeIds) async {
    CollectionReference storeCollection = fs.collection('stores');
    List<Store> stores = await Future.wait(storeIds.map((e) async =>
        Store.fromJson((await storeCollection.doc(e).get()).data()
            as Map<String, dynamic>)));
    return stores;
  }

  static Future<void> notificationTest(
      String email, NotificationBase notif) async {
    DocumentReference users = fs.collection('users').doc(email);
    fs.runTransaction((transaction) async {
      transaction.update(users, {'notification.${notif.time}': notif.toJson()});
    });
  }

  static void changeThumbnail(String email, String storeId) async {
    try {
      String? newThumbnail = await CloudStorageMethods.addImage(email, storeId);
      if (newThumbnail == null) throw FirebaseException;
      CollectionReference stores = fs.collection('stores');
      stores.doc(storeId).update({'thumbnail': newThumbnail});
    } catch (e) {}
  }

  static void clearNotification(String email) {
    try {
      CollectionReference users = fs.collection('users');
      users.doc(email).update({'notification': {}});
    } catch (e) {}
  }
}

class CloudStorageMethods {
  static Future<String?> addImage(String email, String storeId) async {
    XFile? _image;
    String? url;
    final ImagePicker _picker = ImagePicker();
    try {
      _image = await _picker.pickImage(source: ImageSource.gallery);
      Reference ref =
          FirebaseStorage.instance.ref().child('${storeId}/${_image!.name}');
      await ref.putFile(File(_image.path));
      url = await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }
}
