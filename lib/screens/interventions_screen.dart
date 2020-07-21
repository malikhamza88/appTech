import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:login_example/screens/post_intervention_screen.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  static const routeName = '/intervention';
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime _currentBackPressTime = DateTime.now().add(Duration(seconds: -10));

  Size screenSize;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  Future<bool> _onWillPopScope(BuildContext context) async {
    Navigator.of(context).pop();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.indigo,

      appBar: new AppBar(
        backgroundColor: Colors.cyan[500],
        title: Text("Interventions"),
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      // drawer: DrawerClass(),
      body: RefreshIndicator(
        child: Builder(
            builder: (context) => WillPopScope(
                child: StreamBuilder<TaskPage>(
                  builder: (context, snapshot) {
                    return Padding(
                        padding: EdgeInsets.all(0.0), child: iproject());
                  },
                ),
                onWillPop: () => _onWillPopScope(context))),
        onRefresh: () async {},
      ),
    );
  }

  Widget iproject() {
    final data = Provider.of<AuthProvider>(context);
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: data.fetchAllInterventions(),
        builder: (context, snapshot) {
          return ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.interventions?.length ?? 0,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                color: Colors.white12,
                margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: 25.0,
                height: 180.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(InterventionScreenPage.route(
                        snapshot.data[index].taskId));
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print('testing');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //Container for time and notification
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.title,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 38.0),
                                                      child: Text(
                                                        ' ${snapshot.data[index].nom}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    Divider(color: Colors.black),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //Container for time and notification
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person_outline,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.0),
                                                      child: Text(
                                                        '${snapshot.data[index].pce}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.remove_red_eye),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),


                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //Container for time and notification
                                        Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.place,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                3.0),
                                                            child: Text(
                                                              '${snapshot.data[index].num} ${snapshot.data[index].rue} ${snapshot.data[index].codePostal} ${snapshot.data[index].commune}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //Container for time and notification

                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 12.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.black,
                                                          size: 20.0,
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10.0),
                                                          child: Text(
                                                            '${snapshot.data[index].dateIntervention}${snapshot.data[index].horraire}',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
