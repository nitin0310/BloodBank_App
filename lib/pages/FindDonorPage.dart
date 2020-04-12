import 'package:bloodroid/pages/mainprofile2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindDonorPage extends StatefulWidget {
  @override
  _FindDonorPageState createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {

  List<String> bloodGps = ["A+","B+","O+","O-","A-","AB+","B-","AB-"];
  List<String> statesList = ["Punjab"];
  List<String> citiesList = ['Amritsar','Barnala', 'Bathinda', 'Firozpur', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Sri Muktsar Sahib', 'Pathankot', 'Patiala', 'Rupnagar','Ajitgarh (Mohali)', 'Sangrur', 'Nawanshahr', 'Tarn Taran',];

  var currentBloodGpValue;
  var curCity;
  var curState;
  String description;
  FirebaseUser currentUser;

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference collectionReferenceUsers = Firestore.instance.collection('users');
  CollectionReference collectionReferenceRequests = Firestore.instance.collection('requests');

  Color selectcolorblood,selectcolorhos,selectcolorcity = Colors.black54;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh,color: Colors.white,), onPressed:()=>getCurrentUser())
          ],
          title: Text("Find donors",
            style: TextStyle(
              color: Colors.white),),
        backgroundColor: Colors.red[800],
        ),
        body: currentUser == null?Center(child: CircularProgressIndicator(),):
        StreamBuilder(
          stream: collectionReferenceUsers.document(currentUser.uid.toString()).snapshots(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                    child: DropdownButton<String>(
                      hint: Center(child: Text("Select Blood Group"),),
                      items: bloodGps.map((String dropdownValue){
                        return DropdownMenuItem<String>(
                          child: Center(child: Text("$dropdownValue",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),)),
                          value: dropdownValue,
                        );
                      }).toList(),

                      onChanged: (String value){
                        setState(() {
                          currentBloodGpValue = value;
                          selectcolorblood = Colors.red[600];
                        });
                      },
                      value: currentBloodGpValue,
                      isExpanded: true,
                      icon: Icon(Icons.opacity),
                      iconEnabledColor: selectcolorblood,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                    child: DropdownButton<String>(
                      hint: Center(child: Text("Select State"),),
                      items: statesList.map((String dropdownvalue){
                        return DropdownMenuItem<String>(
                          child: Center(child: Text("$dropdownvalue",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),)),
                          value: dropdownvalue,
                        );
                      }).toList(),
                      onChanged: (String value){
                        setState(() {
                          curState = value;
                          selectcolorcity = Colors.red[600];
                        });
                      },
                      value: curState,
                      isExpanded: true,
                      icon: Icon(Icons.navigation),
                      iconEnabledColor: selectcolorcity,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                    child: DropdownButton<String>(
                      hint: Center(child: Text("Select City"),),
                      items: citiesList.map((String dropdownvalue){
                        return DropdownMenuItem<String>(
                          child: Center(child: Text("$dropdownvalue",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),)),
                          value: dropdownvalue,
                        );
                      }).toList(),
                      onChanged: (String value){
                        setState(() {
                          curCity = value;
                          selectcolorhos = Colors.red[600];
                        });
                      },
                      value: curCity,
                      isExpanded: true,
                      icon: Icon(Icons.local_hospital),
                      iconEnabledColor: selectcolorhos,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15.0,top: 10.0),
                    child: Container(
                      height: 50.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          hintText: "Additional description.(Optional)",
                        ),
                        onChanged: (value){
                          this.description = value;
                        },
                      ),
                    ),
                  ),

                  Container(
                    margin:EdgeInsets.only(top: 35.0),
                    height: 60.0,
                    width: (MediaQuery.of(context).size.width)/1.7,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: (){
                          postRequest(snapshot);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        color: Colors.red[600],
                        child: Text("Post",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),),
                        elevation: 7.0,
                        splashColor: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        )
      ),
    );
  }

  Future getCurrentUser() async {
    FirebaseUser user = await auth.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future postRequest(AsyncSnapshot snapshot) async{

    print(snapshot.data['username']);

    Map<String,String> data = {
      'name':snapshot.data['username'],
      'blood group':currentBloodGpValue.toString(),
      'contact':snapshot.data['contact'],
      'city':curCity.toString(),
      'state':curState.toString(),
      'description':description.toString(),
      'userImage':snapshot.data['userImage'],
    };

    collectionReferenceRequests.document(currentUser.uid.toString()).setData(data).then((value){
      showDialog(
          barrierDismissible: false,
          context: (context),
          builder: (BuildContext context){
            return SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)
                ),
                title: Text("Request status"),
                content: Text("Request upload done."),
                actions: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                    ),
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
      Navigator.pop(context);
    }).catchError((e){
      print(e.toString());
    });

  }

}
