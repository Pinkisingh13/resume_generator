import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/resume.dart';
import '../services/pdf_service.dart';
import 'resume_form_screen.dart';

class ResumeDetailScreen extends StatelessWidget {
  final Resume resume;

  const ResumeDetailScreen({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Resume',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumeFormScreen(resumeToEdit: resume),
                ),
              );
            },
          ),
          if (resume.aiResume != null && resume.aiResume!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy AI Resume',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: resume.aiResume!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Resume copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfo(context),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            if (resume.about != null && resume.about!.isNotEmpty) ...[
              _buildSectionTitle('About'),
              const SizedBox(height: 8),
              Text(
                resume.about!,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle('Skills'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Education'),
            const SizedBox(height: 12),
            ...resume.education.map((edu) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (edu.degree != null && edu.degree!.isNotEmpty)
                        Text(
                          edu.degree!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (edu.institute != null && edu.institute!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          edu.institute!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                      if (edu.startYear != null || edu.endYear != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${edu.startYear ?? ''} - ${edu.endYear ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      if (edu.percentage != null && edu.percentage!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Grade: ${edu.percentage}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            if (resume.workexperience != null && resume.workexperience!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Work Experience'),
              const SizedBox(height: 12),
              ...resume.workexperience!.map((work) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (work.title != null && work.title!.isNotEmpty)
                          Text(
                            work.title!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (work.company != null && work.company!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            work.company!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                        if (work.start != null || work.end != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${work.start ?? ''} - ${work.end ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        if (work.details != null && work.details!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ...work.details!.map((detail) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(fontSize: 16)),
                                  Expanded(child: Text(detail)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
            if (resume.projects != null && resume.projects!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Projects'),
              const SizedBox(height: 12),
              ...resume.projects!.map((project) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (project.name != null && project.name!.isNotEmpty)
                          Text(
                            project.name!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (project.description != null && project.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            project.description!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        if (project.tech != null && project.tech!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: project.tech!.map((tech) {
                              return Chip(
                                label: Text(tech, style: const TextStyle(fontSize: 12)),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          ),
                        ],
                        if (project.link != null && project.link!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Link: ${project.link}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
            if (resume.aiResume != null && resume.aiResume!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.purple[700]),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Generated Resume',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: SelectableText(
                  resume.aiResume!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final pdfService = PdfService();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.visibility,
                label: 'Preview',
                isPrimary: true,
                onPressed: () async {
                  try {
                    await pdfService.previewPdf(resume);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.download,
                label: 'Download',
                isPrimary: false,
                onPressed: () async {
                  try {
                    final path = await pdfService.downloadPdf(resume);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            path != null
                              ? 'PDF saved successfully!'
                              : 'Failed to save PDF',
                          ),
                          backgroundColor: path != null ? Colors.green : Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                isPrimary: false,
                onPressed: () async {
                  try {
                    await pdfService.sharePdf(resume);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      );
    }
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                resume.fullname.isNotEmpty ? resume.fullname[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              resume.fullname,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email, resume.email),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, resume.mobileNumber),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, resume.location),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
