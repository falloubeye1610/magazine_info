import 'package:flutter/material.dart';

import 'redacteur_interface.dart';

class LoginInterface extends StatefulWidget {
  const LoginInterface({super.key});

  @override
  State<LoginInterface> createState() => _LoginInterfaceState();
}

class _LoginInterfaceState extends State<LoginInterface> {
  // Contrôleurs des champs de saisie.
  final TextEditingController _utilisateurController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  // Identifiants attendus (authentification locale simple pour la démo).
  static const String _utilisateurAttendu = 'admin';
  static const String _motDePasseAttendu = 'admin';

  // Message d'erreur affiché en cas d'échec ; null quand tout va bien.
  String? _messageErreur;
  bool _motDePasseVisible = false;

  @override
  void dispose() {
    _utilisateurController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  // Vérifie les identifiants et redirige vers l'écran principal si valides.
  void _seConnecter() {
    final utilisateur = _utilisateurController.text.trim();
    final motDePasse = _motDePasseController.text;

    // Validation : aucun champ ne doit être vide.
    if (utilisateur.isEmpty || motDePasse.isEmpty) {
      setState(() {
        _messageErreur = 'Veuillez saisir votre nom d\'utilisateur et votre mot de passe.';
      });
      return;
    }

    // Vérification des identifiants.
    if (utilisateur != _utilisateurAttendu || motDePasse != _motDePasseAttendu) {
      setState(() {
        _messageErreur = 'Nom d\'utilisateur ou mot de passe incorrect.';
      });
      return;
    }

    // Authentification réussie : on remplace l'écran de connexion par l'écran principal.
    setState(() => _messageErreur = null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RedacteurInterface()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Image d'en-tête.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/magazineInfo.jpg',
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Magazine Infos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Connectez-vous pour accéder à vos rédacteurs',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 28),
              // Champ nom d'utilisateur.
              TextField(
                controller: _utilisateurController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Champ mot de passe.
              TextField(
                controller: _motDePasseController,
                obscureText: !_motDePasseVisible,
                onSubmitted: (_) => _seConnecter(),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _motDePasseVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                      () => _motDePasseVisible = !_motDePasseVisible,
                    ),
                  ),
                ),
              ),
              // Message d'erreur (affiché uniquement en cas d'échec).
              if (_messageErreur != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _messageErreur!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Bouton de connexion.
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _seConnecter,
                  icon: const Icon(Icons.login),
                  label: const Text('Connexion'),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Identifiants de démonstration : admin / admin',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
