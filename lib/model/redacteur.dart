import 'dart:convert';

class Redacteur {
  final String? id;
  final String nom;
  final String prenom;
  final String email;

  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  //Methode toMap
  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  //Methode fromMap
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }

  //Methode toJson
  String toJson() {
    return json.encode(toMap());
  }

  //Methode fromJson
  factory Redacteur.fromJson(String source) =>
      Redacteur.fromMap(json.decode(source));
}
