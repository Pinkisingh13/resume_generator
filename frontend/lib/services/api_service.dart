import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/resume.dart';

class ApiService {
  // Automatically use correct URL based on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/resume-generator';
    } else {
      return 'http://localhost:8000/api/resume-generator';
    }
  }

  // Get all resumes
  Future<List<Resume>> getAllResumes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-resume'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> resumes = data['All Saved Resumes'];
        return resumes.map((json) => Resume.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load resumes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching resumes: $e');
    }
  }

  // Create AI-generated resume
  Future<Resume> buildAIResume(Map<String, dynamic> resumeData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/build-ai-resume'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(resumeData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Resume.fromJson(data['resume']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create resume');
      }
    } catch (e) {
      throw Exception('Error creating resume: $e');
    }
  }

  // Update resume
  Future<Resume> updateResume(String id, Map<String, dynamic> resumeData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-resume/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(resumeData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Resume.fromJson(data['updatedResume']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update resume');
      }
    } catch (e) {
      throw Exception('Error updating resume: $e');
    }
  }

  // Delete resume
  Future<void> deleteResume(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete-resume/$id'),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete resume');
      }
    } catch (e) {
      throw Exception('Error deleting resume: $e');
    }
  }
}
