import 'package:flutter/material.dart';

import '../model/redacteur.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _db = DatabaseManager();

  // Contrôleurs des champs de saisie du formulaire d'ajout.
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Liste des rédacteurs affichés à l'écran.
  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs(); // charge les données déjà enregistrées au démarrage
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Récupère tous les rédacteurs depuis la base et rafraîchit la vue.
  Future<void> _chargerRedacteurs() async {
    final liste = await _db.getAllRedacteurs();
    setState(() {
      _redacteurs = liste;
    });
  }

  // Ajoute un rédacteur à partir des champs saisis.
  Future<void> _ajouterRedacteur() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();

    // Validation simple : aucun champ ne doit être vide.
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final redacteur = Redacteur.sansId(nom: nom, prenom: prenom, email: email);
    await _db.insertRedacteur(redacteur);

    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    await _chargerRedacteurs();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rédacteur ajouté')),
    );
  }

  // Boîte de dialogue de modification pré-remplie avec les valeurs actuelles.
  Future<void> _modifierRedacteur(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier Rédacteur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nouveau Nom'),
                ),
                TextField(
                  controller: prenomController,
                  decoration:
                      const InputDecoration(labelText: 'Nouveau Prénom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Nouvel Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final modifie = Redacteur(
                  id: redacteur.id, // on conserve l'id existant
                  nom: nomController.text.trim(),
                  prenom: prenomController.text.trim(),
                  email: emailController.text.trim(),
                );
                await _db.updateRedacteur(modifie);
                if (context.mounted) Navigator.pop(context);
                await _chargerRedacteurs();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Boîte de dialogue de confirmation avant suppression.
  Future<void> _supprimerRedacteur(Redacteur redacteur) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer Rédacteur'),
          content: Text(
            'Voulez-vous vraiment supprimer ${redacteur.nom} ${redacteur.prenom} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await _db.deleteRedacteur(redacteur.id!);
                if (context.mounted) Navigator.pop(context);
                await _chargerRedacteurs();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des rédacteurs'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Zone de saisie
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                onPressed: _ajouterRedacteur,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un Rédacteur'),
              ),
            ),
            const SizedBox(height: 12),
            // Liste des rédacteurs
            Expanded(
              child: _redacteurs.isEmpty
                  ? const Center(child: Text('Aucun rédacteur enregistré'))
                  : ListView.builder(
                      itemCount: _redacteurs.length,
                      itemBuilder: (context, index) {
                        final redacteur = _redacteurs[index];
                        return Card(
                          child: ListTile(
                            title: Text('${redacteur.nom} ${redacteur.prenom}'),
                            subtitle: Text(redacteur.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _supprimerRedacteur(redacteur),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _modifierRedacteur(redacteur),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
