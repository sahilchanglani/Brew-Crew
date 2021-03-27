import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection = Firestore.instance.collection('Brews');

  Future updateUserData(String sugars, String name, int strength) async{
    return await brewCollection.document(uid).setData({
      'sugars':sugars,
      'name':name,
      'strength':strength,
    });  
  }
  //List of brew from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Brew(
        sugars: doc.data['sugars'] ?? '0',
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0
      );
    }).toList();
  }
  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }
  // UserData from Doc snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      strength: snapshot.data['strength'],
      sugars: snapshot.data['sugars']
    );
  }
  // GET User doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

}