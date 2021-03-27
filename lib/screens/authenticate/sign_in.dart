import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0,
          title: Text('Sign in to Brew Crew'),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  widget.toggleView();
                },
                icon: Icon(Icons.person),
                label: Text('Register'))
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText :'Email'),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    email = val;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText :'Password'),
                  validator: (val) => val.length < 6? "Enter password with 6+ characters" : null,
                  obscureText: true,
                  onChanged: (val) {
                    password = val;
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                    color: Colors.pink[400],
                    child: Text('Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInWithEmail(email: email, password: password);
                        if(result == null){
                          setState(() {
                            error = 'Please enter valid credentials';
                            loading = false;
                          });
                        }
                      }
                    }),
                SizedBox(height: 12,),
                Text(error,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize : 12
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}
