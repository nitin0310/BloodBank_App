import 'package:bloodroid/pages/mainprofile2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  var dateday = DateTime.now().day;
  var datemonth = DateTime.now().month;
  var dateyear = DateTime.now().year;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DocumentReference documentReference;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String userName,contact,bloodGp;
  String state,city;
  List<String> bloodGps = ["A+","B+","O+","O-","A-","AB+","B-","AB-"];
  List<String> statesList = ["Punjab"];
  List<String> citiesList = ['Amritsar','Barnala', 'Bathinda', 'Firozpur', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Sri Muktsar Sahib', 'Pathankot', 'Patiala', 'Rupnagar','Ajitgarh (Mohali)', 'Sangrur', 'Nawanshahr', 'Tarn Taran',];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Text("Update Profile",
            style: TextStyle(
                color: Colors.white,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  height: 155.0,
                  color: Colors.red[400],
                ),
              ),
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: 105.0,
                  color: Colors.red[700],
                ),
              ),
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  height: 85.0,
                  color: Colors.red[900],
                ),
              ),
              Positioned(
                  top: 30.0,
                  left: 10.0,
                  child: Icon(
                    Icons.invert_colors,
                    color: Colors.white,
                    size: 70.0,
                  )),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                  ),
                  MainProfile2(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width)/1.7,
                    child: RaisedButton(
                      elevation: 9.0,
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: Colors.red[700],
                      child: Text("Update Details",style: TextStyle(
                        color: Colors.white,
                      ),),

                      onPressed: (){
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context){
                            return SingleChildScrollView(
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                elevation: 25.0,
                                title: Column(
                                  children: <Widget>[
                                    Text("Update your details",),
                                    Text("Note: Don't leave any field blank",style: TextStyle(color: Colors.red[800],fontSize: 15.0),),
                                  ],
                                ),
                                content: Column(
                                  children: <Widget>[
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10.0,),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                ),
                                                hintText: "Enter name",
                                                labelText: "Name",
                                              ),
                                              onChanged: (value){
                                                this.userName = value;
                                              },
                                              validator: (value){
                                                if(value.length == 0 && value == null){
                                                  return "Enter valid name";
                                                }else{
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),

                                          SizedBox(height: 10.0,),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                ),
                                                hintText: "Enter contact no.",
                                                labelText: "Contact",
                                              ),
                                              onChanged: (value){
                                                this.contact = value;
                                              },
                                              validator: (value){
                                                if(value.length != 10){
                                                  return "Enter valid 10-digit number";
                                                }else{
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),

                                          SizedBox(height: 10.0,),

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
                                                this.bloodGp = value;
                                            },
                                            isExpanded: true,
                                            icon: Icon(Icons.opacity),
                                            iconEnabledColor: Colors.red[800],
                                            value: bloodGp,
                                          ),

                                          SizedBox(height: 10.0,),

                                          DropdownButton<String>(
                                            hint: Center(child: Text("Select City")),
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
                                                this.city = value;
                                            },
                                            isExpanded: true,
                                            iconEnabledColor: Colors.red[800],
                                            value: city,
                                          ),

                                          SizedBox(height: 10.0,),

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
                                                this.state = value;
                                            },
                                            isExpanded: true,
                                            iconEnabledColor: Colors.red[800],
                                            value: state,
                                          ),

                                          SizedBox(height: 30.0,),

                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedButton(
                                          color:Colors.red[800],
                                          child: Text("Ok",style: TextStyle(color: Colors.white),),
                                          onPressed: (){
                                            updateUserDetails();
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },

                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Date: ",style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),),
                      Text("${dateday}/ ${datemonth}/ ${dateyear}",style: TextStyle(
                        fontSize: 17.0,
                      ),)
                    ],
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width)/1.2,
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.red[800],
                    ),
                  )
                ],
              )
            ],

          ),
        ),
      ),
    );
  }

  Future updateUserDetails() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      getCurrentUser();
      print(currentUser.uid.toString());
      documentReference = Firestore.instance.collection('users').document (currentUser.uid.toString());

      Map<String,String> data = {
        'username':userName,
        'contact':contact,
        'blood group':bloodGp,
        'city':city,
        'state':state,
      };
      documentReference.updateData(data).then((value){
        print("Document updated");
        Navigator.pop(context);
      }).catchError((e){
        print(e.toString());
      });

    }

  }

  Future getCurrentUser() async{
    FirebaseUser user = await auth.currentUser();
    setState(() {
      this.currentUser = user;
    });
  }

}
