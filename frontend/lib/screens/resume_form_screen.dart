import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../models/resume.dart';
import '../models/education.dart';
import '../models/work_experience.dart';
import '../models/project.dart';

class ResumeFormScreen extends StatefulWidget {
  final Resume? resumeToEdit;

  const ResumeFormScreen({super.key, this.resumeToEdit});

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutController = TextEditingController();
  final _locationController = TextEditingController();

  final List<TextEditingController> _skillControllers = [TextEditingController()];
  final List<Map<String, TextEditingController>> _educationControllers = [];
  final List<Map<String, dynamic>> _workControllers = [];
  final List<Map<String, dynamic>> _projectControllers = [];

  bool get _isEditing => widget.resumeToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFormWithExistingData();
    }
  }

  void _populateFormWithExistingData() {
    final resume = widget.resumeToEdit!;

    // Populate basic fields
    _fullnameController.text = resume.fullname;
    _mobileController.text = resume.mobileNumber;
    _emailController.text = resume.email;
    _aboutController.text = resume.about ?? '';
    _locationController.text = resume.location;

    // Populate skills
    _skillControllers.clear();
    for (var skill in resume.skills) {
      _skillControllers.add(TextEditingController(text: skill));
    }

    // Populate education
    for (var edu in resume.education) {
      _educationControllers.add({
        'degree': TextEditingController(text: edu.degree ?? ''),
        'institute': TextEditingController(text: edu.institute ?? ''),
        'startYear': TextEditingController(text: edu.startYear ?? ''),
        'endYear': TextEditingController(text: edu.endYear ?? ''),
        'percentage': TextEditingController(text: edu.percentage ?? ''),
      });
    }

    // Populate work experience
    if (resume.workexperience != null) {
      for (var work in resume.workexperience!) {
        _workControllers.add({
          'title': TextEditingController(text: work.title ?? ''),
          'company': TextEditingController(text: work.company ?? ''),
          'start': TextEditingController(text: work.start ?? ''),
          'end': TextEditingController(text: work.end ?? ''),
          'details': TextEditingController(text: work.details?.join(', ') ?? ''),
        });
      }
    }

    // Populate projects
    if (resume.projects != null) {
      for (var project in resume.projects!) {
        _projectControllers.add({
          'name': TextEditingController(text: project.name ?? ''),
          'description': TextEditingController(text: project.description ?? ''),
          'tech': TextEditingController(text: project.tech?.join(', ') ?? ''),
          'link': TextEditingController(text: project.link ?? ''),
        });
      }
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    for (var controller in _skillControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Resume' : 'Create AI Resume'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Personal Information'),
            _buildTextField(
              controller: _fullnameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val?.isEmpty ?? true) return 'Required';
                if (!val!.contains('@')) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              icon: Icons.location_on,
              validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _aboutController,
              label: 'About / Summary',
              icon: Icons.info,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Skills'),
            ..._buildSkillsSection(),
            const SizedBox(height: 32),
            _buildSectionHeader('Education'),
            ..._buildEducationSection(),
            const SizedBox(height: 32),
            _buildSectionHeader('Work Experience (Optional)'),
            ..._buildWorkExperienceSection(),
            const SizedBox(height: 32),
            _buildSectionHeader('Projects (Optional)'),
            ..._buildProjectsSection(),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(_isEditing ? Icons.update : Icons.auto_awesome),
                label: Text(_isEditing ? 'Update Resume' : 'Generate AI Resume'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  List<Widget> _buildSkillsSection() {
    return [
      ..._skillControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final controller = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Skill ${index + 1}',
                    prefixIcon: const Icon(Icons.stars),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (val) =>
                      index == 0 && (val?.isEmpty ?? true) ? 'At least one skill required' : null,
                ),
              ),
              if (_skillControllers.length > 1)
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      controller.dispose();
                      _skillControllers.removeAt(index);
                    });
                  },
                ),
            ],
          ),
        );
      }),
      TextButton.icon(
        onPressed: () {
          setState(() {
            _skillControllers.add(TextEditingController());
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
      ),
    ];
  }

  List<Widget> _buildEducationSection() {
    return [
      ..._educationControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final controllers = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Education ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          controllers.values.forEach((c) => c.dispose());
                          _educationControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['degree'],
                  decoration: const InputDecoration(
                    labelText: 'Degree',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['institute'],
                  decoration: const InputDecoration(
                    labelText: 'Institute',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers['startYear'],
                        decoration: const InputDecoration(
                          labelText: 'Start Year',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: controllers['endYear'],
                        decoration: const InputDecoration(
                          labelText: 'End Year',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['percentage'],
                  decoration: const InputDecoration(
                    labelText: 'Grade/Percentage',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      TextButton.icon(
        onPressed: () {
          setState(() {
            _educationControllers.add({
              'degree': TextEditingController(),
              'institute': TextEditingController(),
              'startYear': TextEditingController(),
              'endYear': TextEditingController(),
              'percentage': TextEditingController(),
            });
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Education'),
      ),
    ];
  }

  List<Widget> _buildWorkExperienceSection() {
    return [
      ..._workControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final controllers = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Experience ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _workControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['title'],
                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['company'],
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers['start'],
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: controllers['end'],
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['details'],
                  decoration: const InputDecoration(
                    labelText: 'Work Details (comma-separated)',
                    hintText: 'e.g., Built mobile app, Led team of 5',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        );
      }),
      TextButton.icon(
        onPressed: () {
          setState(() {
            _workControllers.add({
              'title': TextEditingController(),
              'company': TextEditingController(),
              'start': TextEditingController(),
              'end': TextEditingController(),
              'details': TextEditingController(),
            });
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Work Experience'),
      ),
    ];
  }

  List<Widget> _buildProjectsSection() {
    return [
      ..._projectControllers.asMap().entries.map((entry) {
        final index = entry.key;
        final controllers = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Project ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _projectControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['name'],
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['description'],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['tech'],
                  decoration: const InputDecoration(
                    labelText: 'Tech Stack (comma-separated)',
                    hintText: 'e.g., Flutter, Node.js, MongoDB',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['link'],
                  decoration: const InputDecoration(
                    labelText: 'Project Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      TextButton.icon(
        onPressed: () {
          setState(() {
            _projectControllers.add({
              'name': TextEditingController(),
              'description': TextEditingController(),
              'tech': TextEditingController(),
              'link': TextEditingController(),
            });
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
      ),
    ];
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final skills = _skillControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final education = _educationControllers.map((controllers) {
      return Education(
        degree: controllers['degree']!.text,
        institute: controllers['institute']!.text,
        startYear: controllers['startYear']!.text,
        endYear: controllers['endYear']!.text,
        percentage: controllers['percentage']!.text,
      ).toJson();
    }).toList();

    final workExperience = _workControllers.map((controllers) {
      final detailsText = controllers['details']!.text.trim();
      final detailsList = detailsText.isNotEmpty
          ? detailsText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : null;

      return WorkExperience(
        title: controllers['title']!.text,
        company: controllers['company']!.text,
        start: controllers['start']!.text,
        end: controllers['end']!.text,
        details: detailsList,
      ).toJson();
    }).toList();

    final projects = _projectControllers.map((controllers) {
      final techText = controllers['tech']!.text.trim();
      final techList = techText.isNotEmpty
          ? techText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : null;

      return Project(
        name: controllers['name']!.text,
        description: controllers['description']!.text,
        tech: techList,
        link: controllers['link']!.text,
      ).toJson();
    }).toList();

    final resumeData = {
      'fullname': _fullnameController.text,
      'email': _emailController.text,
      'mobileNumber': _mobileController.text,
      'location': _locationController.text,
      'about': _aboutController.text,
      'skills': skills,
      'education': education,
      if (workExperience.isNotEmpty) 'workexperience': workExperience,
      if (projects.isNotEmpty) 'projects': projects,
    };

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  _isEditing
                    ? 'Updating Resume & Regenerating AI Resume...'
                    : 'Generating AI Resume...',
                  textAlign: TextAlign.center,
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'This may take a moment',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    final bool success;
    if (_isEditing) {
      success = await context.read<ResumeProvider>().updateResume(
        widget.resumeToEdit!.id!,
        resumeData,
      );
    } else {
      final resume = await context.read<ResumeProvider>().createAIResume(resumeData);
      success = resume != null;
    }

    if (!mounted) return;

    Navigator.pop(context);

    if (success) {
      // Pop the form screen and the detail screen (if editing)
      if (_isEditing) {
        Navigator.pop(context); // Pop form
        Navigator.pop(context); // Pop detail screen
      } else {
        Navigator.pop(context); // Pop form only
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Resume updated successfully!' : 'Resume created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<ResumeProvider>().error ?? (_isEditing ? 'Failed to update resume' : 'Failed to create resume'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
