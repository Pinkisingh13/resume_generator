import 'work_experience.dart';
import 'education.dart';
import 'project.dart';

class Resume {
  final String? id;
  final String fullname;
  final String mobileNumber;
  final String email;
  final String? about;
  final String location;
  final List<WorkExperience>? workexperience;
  final List<Education> education;
  final List<Project>? projects;
  final String? aiResume;
  final List<String> skills;
  final Map<String, dynamic>? rawDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Resume({
    this.id,
    required this.fullname,
    required this.mobileNumber,
    required this.email,
    this.about,
    required this.location,
    this.workexperience,
    required this.education,
    this.projects,
    this.aiResume,
    required this.skills,
    this.rawDetails,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'mobileNumber': mobileNumber,
      'email': email,
      'about': about,
      'location': location,
      'workexperience': workexperience?.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'projects': projects?.map((e) => e.toJson()).toList(),
      'aiResume': aiResume,
      'skills': skills,
      'rawDetails': rawDetails,
    };
  }

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['_id'],
      fullname: json['fullname'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      about: json['about'],
      location: json['location'] ?? '',
      workexperience: json['workexperience'] != null
          ? (json['workexperience'] as List)
              .map((e) => WorkExperience.fromJson(e))
              .toList()
          : null,
      education: json['education'] != null
          ? (json['education'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : [],
      projects: json['projects'] != null
          ? (json['projects'] as List).map((e) => Project.fromJson(e)).toList()
          : null,
      aiResume: json['aiResume'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      rawDetails: json['rawDetails'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
