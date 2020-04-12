import 'package:bloodroid/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  CollectionReference collectionReferenceUsers = Firestore.instance.collection('users');

  List<String> statesList = ["Punjab"];
  List<String> citiesList = ['Amritsar','Barnala', 'Bathinda', 'Firozpur', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Sri Muktsar Sahib', 'Pathankot', 'Patiala', 'Rupnagar','Ajitgarh (Mohali)', 'Sangrur', 'Nawanshahr', 'Tarn Taran',];

  FirebaseUser currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email,password,userName,contact;
  String bloodGp;
  int contributions = 0;
  int rewards = 0;
  String state;
  String city;
  List<String> bloodGps = ["A+","B+","O+","O-","A-","AB+","B-","AB-"];
  Color changeBloodColor = Colors.black54;

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
                    child: Text("Sign Up",style: TextStyle(
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
                        this.email = value;
                      },
                      validator: (value){
                        if(value == null){
                          return "Please enter valid email id";
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
                        if(value == null || password.length!=8){
                          return "Enter password btw 1-8 characters.";
                        }else{
                          return null;
                        }
                      },
                    ),


                    SizedBox(
                      height: 15.0,
                    ),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Contact",
                          hintText: "Enter Contact",
                          prefixIcon: Icon(Icons.contacts,color: Colors.red[500],),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red[800],
                              )
                          )
                      ),
                      onChanged: (value){
                        this.contact = value;
                      },
                      validator: (value){
                        if(value == null || value.length!=10){
                          return "Please enter valid contact no.";
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
                          labelText: "Username",
                          hintText: "Enter Username",
                          prefixIcon: Icon(Icons.account_circle,color: Colors.red[500],),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red[800],
                              )
                          )
                      ),
                      onChanged: (value){
                        this.userName = value;
                      },
                      validator: (value){
                        if(value == null){
                          return "Please enter valid username";
                        }else{
                          return null;
                        }
                      },
                    ),

                    SizedBox(
                      height: 15.0,
                    ),


                    DropdownButton<String>(
                      hint: Center(child: Text("Select Blood Group")),
                        items: bloodGps.map((String dropdownValue){
                          return DropdownMenuItem(
                            child: Center(
                                child: Text(dropdownValue.toString(),
                                  style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),)),
                            value: dropdownValue,
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            this.bloodGp = value;
                            this.changeBloodColor = Colors.red[600];
                          });
                        },
                      isExpanded: true,
                      icon: Icon(Icons.opacity),
                      iconEnabledColor: changeBloodColor,
                      value: bloodGp,
                    ),

                    DropdownButton<String>(
                      hint: Center(child: Text("Select State")),
                      items: statesList.map((String dropdownValue){
                        return DropdownMenuItem(
                          child: Center(
                              child: Text(dropdownValue.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),)),
                          value: dropdownValue,
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          this.state = value;
                        });
                      },
                      isExpanded: true,
                      iconEnabledColor: Colors.red[800],
                      value: state,
                    ),

                    DropdownButton<String>(
                      hint: Center(child: Text("Select city")),
                      items: citiesList.map((String dropdownValue){
                        return DropdownMenuItem(
                          child: Center(
                              child: Text(dropdownValue.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),)),
                          value: dropdownValue,
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          this.city = value;
                        });
                      },
                      isExpanded: true,
                      iconEnabledColor: Colors.red[800],
                      value: city,
                    ),

                  ],
                ),
              ),
            ),

            Hero(
              tag: "signuphero",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: (MediaQuery.of(context).size.width)/1.7,
                    child: RaisedButton(
                      onPressed: (){
                        signUpUser();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      color: Colors.red[600],
                      child: Text("Sign Up",style: TextStyle(
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


  void signUpUser(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print("signUpUser called");
      registerUser();
    }else{
      print("Error by signUpUser method");
    }
  }

  Future registerUser() async {
    AuthResult result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value){

      Map<String,String> data = {
        'email':value.user.email,
        'password':password.toString(),
        'contact':contact,
        'username':userName.toString(),
        'blood group':bloodGp.toString(),
        'state':state.toString(),
        'city':city.toString(),
        'contributions':contributions.toString(),
        'rewards':rewards.toString(),
        'userImage':null.toString(),
      };
      print("${value.user.email} registered successfully");
      collectionReferenceUsers.document(value.user.uid).setData(data).then((value){
        print("Data added to databse");
      }).catchError((e){
        print(e.toString());
      });
      setState(() {
        currentUser = value.user;
      });

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
  }


}
