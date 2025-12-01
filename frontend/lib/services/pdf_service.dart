import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/resume.dart';

class PdfService {
 
  Future<pw.Document> generateResumePdf(Resume resume) async {
    final pdf = pw.Document();

    // Load font
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header Section
          _buildHeader(resume, fontBold, font),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 20),

          // About Section
          if (resume.about != null && resume.about!.isNotEmpty) ...[
            _buildSectionTitle('SUMMARY', fontBold),
            pw.SizedBox(height: 8),
            pw.Text(
              resume.about!,
              style: pw.TextStyle(font: font, fontSize: 11, height: 1.5),
            ),
            pw.SizedBox(height: 20),
          ],

          // Skills Section
          _buildSectionTitle('SKILLS', fontBold),
          pw.SizedBox(height: 8),
          _buildSkills(resume.skills, font),
          pw.SizedBox(height: 20),

          // Education Section
          _buildSectionTitle('EDUCATION', fontBold),
          pw.SizedBox(height: 8),
          ...resume.education.map((edu) => _buildEducation(edu, font, fontBold)).toList(),

          // Work Experience Section
          if (resume.workexperience != null && resume.workexperience!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('WORK EXPERIENCE', fontBold),
            pw.SizedBox(height: 8),
            ...resume.workexperience!.map((work) => _buildWorkExperience(work, font, fontBold)).toList(),
          ],

          // Projects Section
          if (resume.projects != null && resume.projects!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('PROJECTS', fontBold),
            pw.SizedBox(height: 8),
            ...resume.projects!.map((project) => _buildProject(project, font, fontBold)).toList(),
          ],

        ],
      ),
    );

    return pdf;
  }

  // Build Header 
  pw.Widget _buildHeader(Resume resume, pw.Font fontBold, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          resume.fullname.toUpperCase(),
          style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.blue900),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${resume.email} | ${resume.mobileNumber}',
          style: pw.TextStyle(font: font, fontSize: 11),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          resume.location,
          style: pw.TextStyle(font: font, fontSize: 11),
        ),
      ],
    );
  }

  // Build section title
  pw.Widget _buildSectionTitle(String title, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 1.5, color: PdfColors.blue900),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blue900),
      ),
    );
  }

  // Build Skills
  pw.Widget _buildSkills(List<String> skills, pw.Font font) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map<pw.Widget>((skill) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
            border: pw.Border.all(color: PdfColors.blue200),
          ),
          child: pw.Text(
            skill,
            style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.blue900),
          ),
        );
      }).toList(),
    );
  }

  // Build Education entry
  pw.Widget _buildEducation(dynamic edu, pw.Font font, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (edu.degree != null && edu.degree!.isNotEmpty)
            pw.Text(
              edu.degree!,
              style: pw.TextStyle(font: fontBold, fontSize: 12),
            ),
          if (edu.institute != null && edu.institute!.isNotEmpty)
            pw.Text(
              edu.institute!,
              style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey700),
            ),
          if (edu.startYear != null || edu.endYear != null)
            pw.Text(
              '${edu.startYear ?? ''} - ${edu.endYear ?? ''}',
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
            ),
          if (edu.percentage != null && edu.percentage!.isNotEmpty)
            pw.Text(
              'Grade: ${edu.percentage}',
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
        ],
      ),
    );
  }

  // Build Work Experience entry
  pw.Widget _buildWorkExperience(dynamic work, pw.Font font, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (work.title != null && work.title!.isNotEmpty)
            pw.Text(
              work.title!,
              style: pw.TextStyle(font: fontBold, fontSize: 12),
            ),
          if (work.company != null && work.company!.isNotEmpty)
            pw.Text(
              work.company!,
              style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey700),
            ),
          if (work.start != null || work.end != null)
            pw.Text(
              '${work.start ?? ''} - ${work.end ?? ''}',
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
            ),
          if (work.details != null && work.details!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            ...work.details!.map<pw.Widget>((detail) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(left: 12, bottom: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ', style: pw.TextStyle(font: font, fontSize: 10)),
                    pw.Expanded(
                      child: pw.Text(
                        detail,
                        style: pw.TextStyle(font: font, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // Build Project entry
  pw.Widget _buildProject(dynamic project, pw.Font font, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (project.name != null && project.name!.isNotEmpty)
            pw.Text(
              project.name!,
              style: pw.TextStyle(font: fontBold, fontSize: 12),
            ),
          if (project.description != null && project.description!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              project.description!,
              style: pw.TextStyle(font: font, fontSize: 10, height: 1.4),
            ),
          ],
          if (project.tech != null && project.tech!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Wrap(
              spacing: 6,
              runSpacing: 4,
              children: project.tech!.map<pw.Widget>((tech) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Text(
                    tech,
                    style: pw.TextStyle(font: font, fontSize: 9),
                  ),
                );
              }).toList(),
            ),
          ],
          if (project.link != null && project.link!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              'Link: ${project.link}',
              style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.blue700),
            ),
          ],
        ],
      ),
    );
  }

  // Preview PDF
  Future<void> previewPdf(Resume resume) async {
    final pdf = await generateResumePdf(resume);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '${resume.fullname}_Resume.pdf',
    );
  }

  // Download PDF
  Future<String?> downloadPdf(Resume resume) async {
    try {
      final pdf = await generateResumePdf(resume);
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/${resume.fullname}_Resume.pdf');
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      return null;
    }
  }

  // Share PDF
  Future<void> sharePdf(Resume resume) async {
    try {
      final pdf = await generateResumePdf(resume);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/${resume.fullname}_Resume.pdf');
      await file.writeAsBytes(await pdf.save());
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '${resume.fullname} - Resume',
      );
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }
}
