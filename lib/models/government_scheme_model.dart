class GovernmentScheme {
  final String id;
  final String name;
  final String description;
  final String category;
  final String state;
  final List<String> eligibility;
  final List<String> benefits;
  final List<String> documents;
  final String applyUrl;
  final DateTime deadline;
  final String imageUrl;

  GovernmentScheme({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.state,
    required this.eligibility,
    required this.benefits,
    required this.documents,
    required this.applyUrl,
    required this.deadline,
    required this.imageUrl,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      state: json['state'] ?? '',
      eligibility: List<String>.from(json['eligibility'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      documents: List<String>.from(json['documents'] ?? []),
      applyUrl: json['applyUrl'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'state': state,
      'eligibility': eligibility,
      'benefits': benefits,
      'documents': documents,
      'applyUrl': applyUrl,
      'deadline': deadline.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
