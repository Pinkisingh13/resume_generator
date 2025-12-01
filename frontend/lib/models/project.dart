class Project {
  final String? name;
  final List<String>? tech;
  final String? description;
  final String? link;

  Project({
    this.name,
    this.tech,
    this.description,
    this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tech': tech,
      'description': description,
      'link': link,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      tech: json['tech'] != null ? List<String>.from(json['tech']) : null,
      description: json['description'],
      link: json['link'],
    );
  }
}
