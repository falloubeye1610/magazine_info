import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

// Classe principale : configuration générale de l'application
class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      home: pageAccueil(),
    );
  }
}

// Écran d'accueil : assemble toutes les parties de l'interface
class pageAccueil extends StatelessWidget {
  const pageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),

      // Le body devient une Column qui invoque successivement chaque partie.
      // SingleChildScrollView évite l'erreur "RenderFlex overflowed"
      // quand le contenu dépasse la hauteur de l'écran.
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/magazineInfo.jpg')),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tu as cliqué dessus')));
        },
        child: const Text('Click'),
      ),
    );
  }
}

// PartieTitre : titre principal + sous-titre
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // occupe toute la largeur disponible
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // alignement en début de ligne
        children: [
          SizedBox(height: 12),
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Votre magazine numérique, votre source d'inspiration",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// PartieTexte : paragraphe descriptif du magazine
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Magazine Infos est bien plus qu'un simple magazine d'informations. "
        "C'est votre passerelle vers le monde, une source inestimable de "
        "connaissances et d'actualités soigneusement sélectionnées pour vous "
        "éclairer sur les enjeux mondiaux, la culture, la science et même le "
        "divertissement.",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 13, height: 1.5),
      ),
    );
  }
}

// PartieIcone : trois actions (TEL, MAIL, PARTAGE)
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        // ← plus de const ici
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1er groupe : Téléphone
          Container(
            child: const Column(
              // ← const sur la Column
              children: [
                Icon(Icons.phone, color: Colors.pink),
                SizedBox(height: 5),
                Text('TEL', style: TextStyle(color: Colors.pink)),
              ],
            ),
          ),
          // 2e groupe : Mail
          Container(
            child: const Column(
              children: [
                Icon(Icons.mail, color: Colors.pink),
                SizedBox(height: 5),
                Text('MAIL', style: TextStyle(color: Colors.pink)),
              ],
            ),
          ),
          // 3e groupe : Partage
          Container(
            child: const Column(
              children: [
                Icon(Icons.share, color: Colors.pink),
                SizedBox(height: 5),
                Text('PARTAGE', style: TextStyle(color: Colors.pink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PartieRubrique : deux images côte à côte avec bords arrondis
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/rubrique1.jpg',
                height: 120,
                fit: BoxFit.cover, 
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/rubrique2.jpg',
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
