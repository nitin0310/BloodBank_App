import 'package:bloodroid/authentication/loginpage.dart';
import 'package:bloodroid/authentication/signuppage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.invert_colors,
                  color: Colors.red[700],
                  size: 180.0,
                ),

                SizedBox(
                  height: 10.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Bloodroid",style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w400
                    ),)
                  ],
                ),

                SizedBox(
                  height: 100.0,
                ),

                Hero(
                  tag: "loginhero",
                  child: Container(
                    height: 50.0,
                      width: (MediaQuery.of(context).size.width)/1.4,
                      child: OutlineButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        splashColor: Colors.red[200],
                        color: Colors.red[800],
                        borderSide: BorderSide(
                          color: Colors.red[500],
                          width: 2.0,
                        ),
                        child: Text("LOGIN",style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.red[500]
                        ),),
                      ),
                    ),
                ),

                SizedBox(
                  height: 20.0,
                ),

                Hero(
                  tag: "signuphero",
                  child: Container(
                    height: 50.0,
                    width: (MediaQuery.of(context).size.width)/1.4,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      color: Colors.red[800],
                      child: Text("SIGN UP",style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),),
                      elevation: 15.0,
                      splashColor: Colors.white,
                    ),
                  ),
                ),

                SizedBox(
                  height: (MediaQuery.of(context).size.height)/4.5,
                ),

                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: (MediaQuery.of(context).size.width)/6,
                          right: (MediaQuery.of(context).size.width)/6,
                      ),
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Text("“Donate blood and be the reason of smile to many faces.”",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red
                        ),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
