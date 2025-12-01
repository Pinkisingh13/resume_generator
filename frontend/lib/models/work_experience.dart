class WorkExperience {
  final String? title;
  final String? company;
  final String? start;
  final String? end;
  final List<String>? details;

  WorkExperience({
    this.title,
    this.company,
    this.start,
    this.end,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'start': start,
      'end': end,
      'details': details,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      title: json['title'],
      company: json['company'],
      start: json['start'],
      end: json['end'],
      details: json['details'] != null
          ? List<String>.from(json['details'])
          : null,
    );
  }
}
