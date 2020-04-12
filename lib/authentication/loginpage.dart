import 'package:bloodroid/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  FirebaseUser currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String email,password;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           Form(
             key: formKey,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(left: 20.0),
                   child: Text("Login",style: TextStyle(
                       color: Colors.red[800],
                       fontSize: 75.0,
                       fontWeight: FontWeight.w500
                   ),),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 20.0),
                   child: Text("here.",style: TextStyle(
                       color: Colors.red[700],
                       fontSize: 35.0,
                       fontWeight: FontWeight.w500
                   ),),
                 ),
               ],
             ),
           ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter email",
                        prefixIcon: Icon(Icons.email,color: Colors.red[500],),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red[800],
                          )
                        ),
                      ),
                      onChanged: (value){
                        setState(() {
                          this.email = value;
                        });
                      },
                      validator: (value){
                        if(value == null && value.contains("@") == false){
                          return "Please enter valid email";
                        }else{
                          return null;
                        }
                      },
                    ),

                    SizedBox(
                      height: 15.0,
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Password here",
                          prefixIcon: Icon(Icons.apps,color: Colors.red[500],),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red[800],
                              )
                          )
                      ),
                      obscureText: true,
                      onChanged: (value){
                        this.password = value;
                      },
                      validator: (value){
                        if(value.length != 8 || value == null){
                          return "Enter password btw 1-8 characters";
                        }else{
                          return null;
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),

            Hero(
              tag: "loginhero",
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: (MediaQuery.of(context).size.width)/1.7,
                      child: RaisedButton(
                        onPressed: (){
                          signInUser();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        color: Colors.red[600],
                        child: Text("Login",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),),
                        elevation: 20.0,
                        splashColor: Colors.white,
                      ),
                    ),
                  ],
                ),
            ),

          ],
        ),
      ),
    );
  }

  Future signInUser() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      AuthResult result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value){
        setState(() {
          currentUser = value.user;
        });
        print("Sign In successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }).catchError((e){
        showDialog(
            barrierDismissible: false,
            context: (context),
            builder: (BuildContext context){
              return SingleChildScrollView(
                child: AlertDialog(
                  title: Text("Sign Up status"),
                  content: Text(e.toString()),
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.red[800],
                      child: Text("Ok",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            }
        );
      });
    }else{
      print("Error by signInUser");
    }
  }



}

