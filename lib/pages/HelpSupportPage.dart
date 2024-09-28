import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide et support'),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildSectionCard(
              'Foire aux questions',
              'Trouvez rapidement des réponses à vos questions',
              Icons.question_answer,
              () {
                // Navigation vers la page FAQ
              },
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              'Contactez-nous',
              'Besoin d\'aide ? Contactez notre équipe de support',
              Icons.contact_support,
              () {
                // Ouvrir la page de contact
              },
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              'Tutoriels vidéo',
              'Apprenez à utiliser l\'application avec nos vidéos',
              Icons.video_library,
              () {
                // Ouvrir la page des tutoriels vidéo
              },
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              'Centre d\'aide en ligne',
              'Consultez notre base de connaissances complète',
              Icons.help_center,
              () {
                // Ouvrir le centre d'aide en ligne
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.teal[400]),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.teal[400]),
            ],
          ),
        ),
      ),
    );
  }
}
