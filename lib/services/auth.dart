import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user from firebaseAuth user
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null? User(uid: user.uid): null;
  }

  Stream<User> get user{
    return _auth.onAuthStateChanged
    .map((FirebaseUser user) => _userFromFirebaseUser(user));
    // or .map(_userFromFirebaseUser);
  }

  // Sign in anonymously
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in with email
  Future signInWithEmail({String email, String password}) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  // Register with email
  Future registerWithEmail({email, password}) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Creating user collection
      await DatabaseService(uid: user.uid).updateUserData("0", "New user", 100);
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }


  // Sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}