import 'package:flutter/material.dart';
import '../models/resume.dart';
import '../services/api_service.dart';

class ResumeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Resume> _resumes = [];
  bool _isLoading = false;
  String? _error;

  List<Resume> get resumes => _resumes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all resumes
  Future<void> fetchResumes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _resumes = await _apiService.getAllResumes();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _resumes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create AI resume
  Future<Resume?> createAIResume(Map<String, dynamic> resumeData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resume = await _apiService.buildAIResume(resumeData);
      _resumes.insert(0, resume);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return resume;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update resume
  Future<bool> updateResume(String id, Map<String, dynamic> resumeData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedResume = await _apiService.updateResume(id, resumeData);
      final index = _resumes.indexWhere((r) => r.id == id);
      if (index != -1) {
        _resumes[index] = updatedResume;
      }
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete resume
  Future<bool> deleteResume(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteResume(id);
      _resumes.removeWhere((r) => r.id == id);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
