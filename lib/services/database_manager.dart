import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/redacteur.dart';

class DatabaseManager {
  // Singleton : une seule instance de gestionnaire de base pour toute l'app.
  DatabaseManager._internal();
  static final DatabaseManager instance = DatabaseManager._internal();
  factory DatabaseManager() => instance;

  Database? _database;

  // Retourne la base ouverte, en l'initialisant au premier appel.
  Future<Database> get database async {
    _database ??= await _initialisation();
    return _database!;
  }

  // Initialise la base SQLite et crée la table redacteurs si besoin.
  Future<Database> _initialisation() async {
    final cheminDossier = await getDatabasesPath();
    final chemin = join(cheminDossier, 'redacteurs.db');

    return openDatabase(
      chemin,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // READ : récupère tous les rédacteurs et les convertit en objets Redacteur.
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> lignes = await db.query('redacteurs');
    return lignes.map((ligne) => Redacteur.fromMap(ligne)).toList();
  }

  // CREATE : insère un nouveau rédacteur et retourne son id généré.
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    final donnees = redacteur.toMap();
    donnees.remove('id'); // laisse SQLite générer l'id auto-incrémenté
    return db.insert('redacteurs', donnees);
  }

  // UPDATE : met à jour la ligne correspondant à l'id du rédacteur.
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // DELETE : supprime la ligne correspondant à l'id.
  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
