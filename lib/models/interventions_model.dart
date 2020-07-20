// To parse this JSON data, do
//
//     final interventions = interventionsFromJson(jsonString);

import 'dart:convert';

Interventions interventionsFromJson(String str) =>
    Interventions.fromJson(json.decode(str));

String interventionsToJson(Interventions data) => json.encode(data.toJson());

class Interventions {
  Interventions({
    this.data,
  });

  List<InterData> data;

  factory Interventions.fromJson(Map<String, dynamic> json) => Interventions(
        data: List<InterData>.from(
            json["data"].map((x) => InterData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InterData {
  InterData({
    this.taskId,
    this.pce,
    this.nom,
    this.emplacement,
    this.num,
    this.rue,
    this.commune,
    this.codePostal,
    this.matriculeCompteur,
    this.anneeCompteur,
    this.situationCompteur,
    this.rRob,
    this.lRob,
    this.typeBranchement,
    this.colonneMontanteGaz,
    this.deposeCompteur,
    this.telClient,
    this.note,
    this.dateIntervention,
    this.status,
    this.horraire,
    this.typeIntervention,
    this.indexDepose,
    this.typeObturation,
    this.typeCondamnation,
    this.comment,
    this.nIntervention,
    this.affectedTo,
    this.signature,
    this.image_1,
    this.image_2,
    this.image_3,
  });

  String taskId;
  dynamic pce;
  dynamic nom;
  dynamic emplacement;
  dynamic num;
  dynamic rue;
  dynamic commune;
  dynamic codePostal;
  dynamic matriculeCompteur;
  dynamic anneeCompteur;
  dynamic situationCompteur;
  dynamic rRob;
  dynamic lRob;
  dynamic typeBranchement;
  dynamic colonneMontanteGaz;
  dynamic deposeCompteur;
  dynamic telClient;
  dynamic note;
  dynamic dateIntervention;
  dynamic status;
  dynamic horraire;
  dynamic typeIntervention;
  dynamic indexDepose;
  dynamic typeObturation;
  dynamic typeCondamnation;
  dynamic comment;
  dynamic nIntervention;
  dynamic affectedTo;
  dynamic signature;
  dynamic image_1;
  dynamic image_2;
  dynamic image_3;

  factory InterData.fromJson(Map<String, dynamic> json) => InterData(
        taskId: json["task_id"],
        pce: json["pce"],
        nom: json["nom"],
        emplacement: json["emplacement"],
        num: json["num"],
        rue: json["rue"],
        commune: json["commune"],
        codePostal: json["code_postal"],
        matriculeCompteur: json["matricule_compteur"],
        anneeCompteur: json["annee_compteur"],
        situationCompteur: json["situation_compteur"],
        rRob: json["r_rob"],
        lRob: json["l_rob"],
        typeBranchement: json["type_branchement"],
        colonneMontanteGaz: json["colonne_montante_gaz"],
        deposeCompteur: json["depose_compteur"],
        telClient: json["tel_client"],
        note: json["note"],
        dateIntervention: json["date_intervention"],
        status: json["status"],
        horraire: json["horraire"],
        typeIntervention: json["type_intervention"],
        indexDepose: json["index_depose"],
        typeObturation: json["type_obturation"],
        typeCondamnation: json["type_condamnation"],
        comment: json["comment"],
        nIntervention: json["n_intervention"],
        affectedTo: json["affected_to"],
        signature: json["signature"],
        image_1: json["image_1"],
        image_2: json["image_2"],
        image_3: json["image_3"],
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "pce": pce,
        "nom": nom,
        "emplacement": emplacement,
        "num": num,
        "rue": rue,
        "commune": commune,
        "code_postal": codePostal,
        "matricule_compteur": matriculeCompteur,
        "annee_compteur": anneeCompteur,
        "situation_compteur": situationCompteur,
        "r_rob": rRob,
        "l_rob": lRob,
        "type_branchement": typeBranchement,
        "colonne_montante_gaz": colonneMontanteGaz,
        "depose_compteur": deposeCompteur,
        "tel_client": telClient,
        "note": note,
        "date_intervention": dateIntervention,
        "status": status,
        "horraire": horraire,
        "type_intervention": typeIntervention,
        "index_depose": indexDepose,
        "type_obturation": typeObturation,
        "type_condamnation": typeCondamnation,
        "comment": comment,
        "n_intervention": nIntervention,
        "affected_to": affectedTo,
        "signature": signature,
        "image_1": image_1,
        "image_2": image_2,
        "image_3": image_3,
      };
}
