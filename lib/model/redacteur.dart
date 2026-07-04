class Redacteur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  // Constructeur avec tous les attributs (id inclus).
  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans id : la base génère l'id automatiquement à l'insertion.
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // Convertit un objet Redacteur en Map pour l'insertion / la mise à jour SQLite.
  // Les clés doivent correspondre exactement aux colonnes de la table redacteurs.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Reconstruit un objet Redacteur à partir d'une ligne de la base.
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}
