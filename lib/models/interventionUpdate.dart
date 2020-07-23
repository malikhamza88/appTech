import 'dart:io';
import 'package:file/memory.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_example/models/interventions_model.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:login_example/widgets/popup.dart';
import 'package:login_example/widgets/popup_content.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

String chipChoice = '';
bool isDespose = false;
bool isMise = true;
bool isAnomalie = false;
bool Deposechoose = false;
bool deposeoui = false;
bool deposedeja = false;

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
  bool _validate = false;
  List<String> chipList = [
    "Dépose Compteur",
    "Mise en sécu",
    "Course vaine",
    "Anomalie",
  ];

  List<String> checkedDObturation;
  List<String> checkCondamnation;

  List<String> deposeList = [
    "Oui",
    "Cpt déjà déposé",
  ];

  Widget _popupBody() {
    return ListView(
      children: <Widget>[
        CheckboxGroup(
          labelStyle: TextStyle(fontSize: 13.0),
          labels: <String>[
            'BOUCHON',
            'PP',
            'DOC',
            'OBTURBATION IMPOSSIBLE',
          ],
          onChange: (bool isChecked, String label, int index) =>
              print("isChecked: $isChecked   label: $label  index: $index"),
          onSelected: (List<String> checked) {
//            print("checked: ${checked.toString()}");
            checkedDObturation = checked;
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Container for time and notification
            //Container for time and notification
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "VALIDER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "REJETER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Colors.red,
                          ),
                          onTap: () {
                            checkedDObturation.clear();
                            Navigator.pop(context);
                          },
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
          height: 20.0,
        ),
      ],
    );
  }

  Widget _popupBody1() {
    return ListView(
      children: <Widget>[
        CheckboxGroup(
          labelStyle: TextStyle(fontSize: 13.0),
          labels: <String>[
            'ROBINET FERMETURE SIMPLE',
            'ROBINET FERME GOUPILE',
            'ROBINET FERME GOUPILE CHICHU',
            'ROBINET FERME BRIDE RETOURNE',
          ],
          onChange: (bool isChecked, String label, int index) =>
              print("isChecked: $isChecked   label: $label  index: $index"),
          onSelected: (List<String> checked) {
            checkCondamnation = checked;
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Container for time and notification
            //Container for time and notification
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "VALIDER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Colors.green,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "REJETER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Colors.red,
                          ),
                          onTap: () {
                            checkCondamnation.clear();
                            Navigator.pop(context);
                          },
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
          height: 20.0,
        ),
      ],
    );
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 20,
        left: 10,
        right: 10,
        bottom: 40,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

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

  AuthProvider _authBloc;
  File signatureFile;
  File _image1;
  File _image2;
  File _image3;
  File _image4;
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

  Future getImage4() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image4 = File(pickedFile.path);
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
//    collectedData['type_obturation'] = checkedDObturation;
//    collectedData['type_condamnation'] = checkCondamnation;
    collectedData['colonne_montante_gaz'] = fetchedData.colonneMontanteGaz;
    collectedData['type_intervention'] = chipChoice;
    collectedData['index_depose'] = _n;
    if (signatureFile != null) {
      collectedData['file'] =
          new UploadFileInfo(signatureFile, signatureFile.path);
    }

    if (_image1 != null) {
      collectedData['image_1'] = new UploadFileInfo(_image1, _image1.path);
    }
    if (_image2 != null) {
      collectedData['image_2'] = new UploadFileInfo(_image2, _image2.path);
    }
    if (_image3 != null) {
      collectedData['image_3'] = new UploadFileInfo(_image3, _image3.path);
    }
    if (_image4 != null && isDespose) {
      collectedData['image_4'] = new UploadFileInfo(_image4, _image4.path);
    }

    print("Collected Data:$collectedData");

    Provider.of<AuthProvider>(context, listen: false)
        .UploadFile(collectedData)
        .then((_) {
      Navigator.of(context).pop();
    });
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
                      if (isDespose)
                        Divider(
                          color: Colors.black,
                          indent: 10.0,
                          endIndent: 10.0,
                        ),
                      if (isDespose)
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Text("Dépose Compteur ?"),
                            )
                          ],
                        ),
                      if (isDespose)
                        SizedBox(
                          height: 10.0,
                        ),
                      if (isDespose)
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          children: <Widget>[
                            deposeChipWidget(deposeList),
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
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Type d\'obturbation"),
                            ],
                          ),
                          onTap: () {
                            showPopup(
                                context, _popupBody(), 'Type d\'obturbation');
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Type condamnation"),
                            ],
                          ),
                          onTap: () {
                            showPopup(
                                context, _popupBody1(), 'Type condamnation');
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
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
                      if (isDespose || isMise)
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
                      if (isDespose || isMise)
                        Divider(
                          color: Colors.black,
                          indent: 10.0,
                          endIndent: 10.0,
                        ),
                      if (isDespose && isMise == false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text("Photo 4"),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: getImage4,
                            ),
                          ],
                        ),
                      if (_image4 != null)
                        Container(
                          width: 400,
                          height: 300,
                          child: Image.file(_image4),
                        ),
                      if (isDespose && isMise == false)
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
              if (item == widget.reportList[0]) {
                isDespose = true;
                isMise = false;
                isAnomalie = false;
              }
              if (item == widget.reportList[1]) {
                isMise = true;
                isDespose = false;
                isAnomalie = true;
              }
              if (item == widget.reportList[2] ||
                  item == widget.reportList[3]) {
                isAnomalie = true;
                isDespose = false;
                isMise = false;
              }
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

class deposeChipWidget extends StatefulWidget {
  final List<String> reportListt;

  deposeChipWidget(this.reportListt);

  @override
  _deposeChipWidgetState createState() => new _deposeChipWidgetState();
}

class _deposeChipWidgetState extends State<deposeChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportListt.forEach((item) {
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
              if (item == widget.reportListt[0]) {
                deposeoui = true;
                deposedeja = false;
              }
              if (item == widget.reportListt[1]) {
                deposedeja = true;
                deposeoui = false;
              }
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
