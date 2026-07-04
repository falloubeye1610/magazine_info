// Tests unitaires du modèle Redacteur (indépendants de la base SQLite).

import 'package:flutter_test/flutter_test.dart';
import 'package:magazine_infos/model/redacteur.dart';

void main() {
  test('toMap() produit les bonnes colonnes', () {
    final r = Redacteur(
      id: 1,
      nom: 'Silina',
      prenom: 'Alice',
      email: 'alice.silina@yahoo.fr',
    );

    expect(r.toMap(), {
      'id': 1,
      'nom': 'Silina',
      'prenom': 'Alice',
      'email': 'alice.silina@yahoo.fr',
    });
  });

  test('Redacteur.sansId a un id null', () {
    final r = Redacteur.sansId(
      nom: 'Yukne',
      prenom: 'Chris',
      email: 'chris.yukne@gmail.com',
    );

    expect(r.id, isNull);
  });

  test('fromMap() reconstruit correctement un Redacteur', () {
    final r = Redacteur.fromMap({
      'id': 5,
      'nom': 'Dupont',
      'prenom': 'Marie',
      'email': 'marie.dupont@mail.com',
    });

    expect(r.id, 5);
    expect(r.nom, 'Dupont');
    expect(r.prenom, 'Marie');
    expect(r.email, 'marie.dupont@mail.com');
  });
}
