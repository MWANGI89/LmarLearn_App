class School {
  final String id;
  final String name;
  final String domain;

  School({
    required this.id,
    required this.name,
    required this.domain,
  });

  factory School.fromMap(String id, Map<String, dynamic> map) {
    return School(
      id: id,
      name: map['name'] ?? '',
      domain: map['domain'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'domain': domain,
      };
}
