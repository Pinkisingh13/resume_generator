class Education {
  final String? degree;
  final String? institute;
  final String? startYear;
  final String? endYear;
  final String? percentage;

  Education({
    this.degree,
    this.institute,
    this.startYear,
    this.endYear,
    this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institute': institute,
      'startYear': startYear,
      'endYear': endYear,
      'percentage': percentage,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      institute: json['institute'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      percentage: json['percentage'],
    );
  }
}
