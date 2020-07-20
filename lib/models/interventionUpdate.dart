import 'dart:io';
import 'package:file/memory.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_example/models/interventions_model.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

String chipChoice = '';

class InterventionUpdatePage extends StatefulWidget {
  final String id;

  InterventionUpdatePage({Key key, this.id}) : super(key: key);

  static Route<dynamic> route({String id}) {
    return MaterialPageRoute(
        builder: (ctx) => InterventionUpdatePage(
              id: id,
            ));
  }

  @override
  _InterventionUpdatePageState createState() => _InterventionUpdatePageState();
}

class _InterventionUpdatePageState extends State<InterventionUpdatePage> {
  List<String> chipList = [
    "Dépose Compteur",
    "Mise en sécu",
    "Course vaine",
    "Anomalie",
  ];

  CameraController _controllers;
  Future<void> _initializeControllerFuture;
  String _myActivityy;
  var collectedData = new Map<String, dynamic>();
  bool _isLoading = false;
  int _n = 0;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  InterData fetchedData;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;

//  void getData() {
//    collectedData['signature'] = Image.memory(ImagePath);
//    print("Collected Data:$collectedData");
//    Provider.of<AuthProvider>(context, listen: false)
//        .postInterventions(collectedData);
//    if (_image1 != null) {
//      AuthProvider().UploadFile(_image1, ImagePath);
//    }
//    Navigator.of(context).pop();
//  }

  AuthProvider _authBloc;
  File signatureFile;
  File _image1;
  File _image2;
  File _image3;
  final picker = ImagePicker();

  Future getImage1() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image1 = File(pickedFile.path);
    });
  }

  Future getImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image2 = File(pickedFile.path);
    });
  }

  Future getImage3() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image3 = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isLoading = true;
        });
        fetchDataById();
      });
    }
  }

  void fetchDataById() async {
    fetchedData = await Provider.of<AuthProvider>(context, listen: false)
        .fetchInterventionById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controllers != null
          ? _initializeControllerFuture = _controllers.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  void add() {
    setState(() {
      _n++;
    });
  }

  void getData() {
    collectedData['task_id'] = widget.id;
    collectedData['date_intervention'] = fetchedData.dateIntervention;
    collectedData['id_technicien'] = "post";
    collectedData['horraire'] = fetchedData.horraire;
    collectedData['num'] = fetchedData.num;
    collectedData['rue'] = fetchedData.rue;
    collectedData['commune'] = fetchedData.commune;
    collectedData['pce'] = fetchedData.pce;
    collectedData['emplacement'] = fetchedData.emplacement;
    collectedData['code_postal'] = fetchedData.codePostal;
    collectedData['matricule_compteur'] = fetchedData.matriculeCompteur;
    collectedData['depose_compteur'] = fetchedData.deposeCompteur;
    collectedData['situation_compteur'] = fetchedData.situationCompteur;
    collectedData['r_rob'] = fetchedData.rRob;
    collectedData['type_branchement'] = fetchedData.typeBranchement;
    collectedData['colonne_montante_gaz'] = fetchedData.colonneMontanteGaz;
    collectedData['type_intervention'] = chipChoice;
    collectedData['index_depose'] = _n;
    collectedData['file'] =
        new UploadFileInfo(signatureFile, signatureFile.path);

    if (_image1 != null) {
      collectedData['image_1'] = new UploadFileInfo(_image1, _image1.path);
    }
    if (_image2 != null) {
      collectedData['image_2'] = new UploadFileInfo(_image2, _image2.path);
    }
    if (_image3 != null) {
      collectedData['image_3'] = new UploadFileInfo(_image3, _image3.path);
    }

    print("Collected Data:$collectedData");

    Provider.of<AuthProvider>(context, listen: false).UploadFile(collectedData);
//    Provider.of<AuthProvider>(context, listen: false)
//        .postInterventions(collectedData);
//    if (_image != null) {
//      AuthProvider().UploadFile(_image, ImagePath);
//    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = 1;
    var data = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[500],
        title: Text('Ajouter Une Intervention'),
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Date d\'intervention'),
                      subtitle: Text('${fetchedData.dateIntervention}'),
                    ),
                    ListTile(
                      title: Text('Technicien'),
                      subtitle: Text('${fetchedData.affectedTo}'),
                    ),
                    ListTile(
                      title: Text("Horaire d'intervention"),
                      subtitle: Text('${fetchedData.horraire}'),
                    ),
                    ListTile(
                      title: Text("Adresse complète"),
                      subtitle: Text(
                          '${fetchedData.num} ${fetchedData.rue} ${fetchedData.commune}'),
                    ),
                    ListTile(
                      title: Text("PCE"),
                      subtitle: Text('${fetchedData.pce}'),
                    ),
                    ListTile(
                      title: Text("Nom"),
                      subtitle: Text('${fetchedData.nom}'),
                    ),
                    ListTile(
                      title: Text("Emplacement"),
                      subtitle: Text('${fetchedData.emplacement}'),
                    ),
                    ListTile(
                      title: Text("Numero"),
                      subtitle: Text('${fetchedData.num}'),
                    ),
                    ListTile(
                      title: Text("Rue"),
                      subtitle: Text('${fetchedData.rue}'),
                    ),
                    ListTile(
                      title: Text("Commune"),
                      subtitle: Text('${fetchedData.commune}'),
                    ),
                    ListTile(
                      title: Text("Code postal"),
                      subtitle: Text('${fetchedData.codePostal}'),
                    ),
                    ListTile(
                      title: Text("Matricule"),
                      subtitle: Text('${fetchedData.matriculeCompteur}'),
                    ),
                    ListTile(
                      title: Text("Débit Compteur"),
                      subtitle: Text('${fetchedData.deposeCompteur}'),
                    ),
                    ListTile(
                      title: Text("Situation compteur"),
                      subtitle: Text('${fetchedData.situationCompteur}'),
                    ),
                    ListTile(
                      title: Text("R Rob"),
                      subtitle: Text('${fetchedData.rRob}'),
                    ),
                    ListTile(
                      title: Text("Type branchement"),
                      subtitle: Text('${fetchedData.typeBranchement}'),
                    ),
                    ListTile(
                      title: Text("Colonne montante gaz"),
                      subtitle: Text('${fetchedData.colonneMontanteGaz}'),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 10.0),
                            child: Text("Intervention réalisable"),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: <Widget>[
                          choiceChipWidget(chipList),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Index depose"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.remove), onPressed: minus),
                              new Text('$_n',
                                  style: new TextStyle(fontSize: 20.0)),
                              IconButton(icon: Icon(Icons.add), onPressed: add),
                            ],
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          //controller: firstName,
                          //focusNode: firstNameNode,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            collectedData['type_obturation'] = value;
                          },
                          initialValue: widget.id == null
                              ? null
                              : fetchedData.typeObturation,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'Type d\'obturbation',
                            labelStyle: TextStyle(color: Colors.purple),
                            labelText: 'Type d\'obturbation',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          //controller: firstName,
                          //focusNode: firstNameNode,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            collectedData['type_condamnation'] = value;
                          },
                          initialValue: widget.id == null
                              ? null
                              : fetchedData.typeCondamnation,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Type condamnation',
                              labelStyle: TextStyle(color: Colors.purple),
                              labelText: 'Type condamnation'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          //controller: firstName,
                          //focusNode: firstNameNode,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            collectedData['comment'] = value;
                          },
                          initialValue:
                              widget.id == null ? null : fetchedData.comment,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Commentaire',
                              labelStyle: TextStyle(color: Colors.purple),
                              labelText: 'Commentaire'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Photo 1"),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: getImage1,
                          ),
                        ],
                      ),
                      if (_image1 != null)
                        Container(
                          width: 400,
                          height: 300,
                          child: Image.file(_image1),
                        ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Photo 2"),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: getImage2,
                          ),
                        ],
                      ),
                      if (_image2 != null)
                        Container(
                          width: 400,
                          height: 300,
                          child: Image.file(_image2),
                        ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Photo 3"),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: getImage3,
                          ),
                        ],
                      ),
                      if (_image3 != null)
                        Container(
                          width: 400,
                          height: 300,
                          child: Image.file(_image3),
                        ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      //SIGNATURE CANVAS
                      Card(
                        child: Signature(
                          controller: _controller,
                          height: 120,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ],
                  ),
                ),
                //OK AND CLEAR BUTTONS
                Card(
                  color: Colors.cyan,
                  //decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //SHOW EXPORTED IMAGE IN NEW ROUTE
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            var data = await _controller.toPngBytes();
                            var image = MemoryImage(data);
                            signatureFile = MemoryFileSystem().file('test.png')
                              ..writeAsBytesSync(data);
                            /*Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(),
                                    body: Center(
                                        child: Container(
                                            color: Colors.grey[300],
                                            child: Image.memory(data))),
                                  );
                                },
                              ),
                            );*/
                          }
                        },
                      ),
                      //CLEAR CANVAS
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.white,
                        onPressed: () {
                          setState(() => _controller.clear());
                        },
                      ),
                    ],
                  ),
                ),
                new SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.green,
                      onPressed: getData,
                      child: Text(
                        "Créer",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(10.0, 10.0),
                    ),
                    MaterialButton(
                      color: Color(0xFFFF0000),
                      child: Text(
                        "Annuler",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

class choiceChipWidget extends StatefulWidget {
  final List<String> reportList;

  choiceChipWidget(this.reportList);

  @override
  _choiceChipWidgetState createState() => new _choiceChipWidgetState();
}

class _choiceChipWidgetState extends State<choiceChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Colors.cyan,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              chipChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
