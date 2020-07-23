import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_example/models/interventionUpdate.dart';
import 'package:login_example/models/interventions_model.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InterventionScreenPage extends StatefulWidget {
  static const routeName = '/interventionScreen';

  InterventionScreenPage({Key key, @required this.id}) : super(key: key);

  static Route<dynamic> route(String id) {
    return MaterialPageRoute(
        builder: (ctx) => InterventionScreenPage(
              id: id,
            ));
  }

  final String id;

  @override
  _InterventionScreenPageState createState() => _InterventionScreenPageState();
}

class _InterventionScreenPageState extends State<InterventionScreenPage> {
  bool _isLoading = false;
  InterData fetchedData;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(InterventionUpdatePage.route(id: widget.id));
        },
        tooltip: 'ajouter une tache',
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.cyan,
      ),
      appBar: new AppBar(
        backgroundColor: Colors.cyan[500],
        title: Text("Intervention Détail"),
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
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
                        onTap: () async {
                          if (fetchedData.num != null &&
                              fetchedData.rue != null &&
                              fetchedData.commune != null) {
                            final String mapsUrl =
                                "https://www.google.com/maps/search/?api=1&query=${fetchedData.num} ${fetchedData.rue} ${fetchedData.commune}";
                            if (await canLaunch(mapsUrl)) {
                              await launch(mapsUrl);
                            }
                          }
                        },
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
                        title: Text("Telephone"),
                        subtitle: Text('${fetchedData.telClient}'),
                        onTap: () async {
                          if (fetchedData.telClient != null) {
                            if (await canLaunch(fetchedData.telClient))
                              await launch("tel://${fetchedData.telClient}");
                          }
                        },
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
                ),
              ],
            ),
    );
  }
}
