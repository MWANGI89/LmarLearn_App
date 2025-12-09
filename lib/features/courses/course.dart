class Course {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String? imageUrl;
  final String category;
  final double? price;
  final bool isFeatured;
  final bool isApproved;
  final int enrollmentCount;
  final double rating;
  final DateTime createdAt;
  final String? instructor;
  final int? duration;
  final String? level;
  final List<String>? tags;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    this.imageUrl,
    this.category = 'Medical',
    this.price,
    this.isFeatured = false,
    this.isApproved = true,
    this.enrollmentCount = 0,
    this.rating = 0.0,
    DateTime? createdAt,
    this.instructor,
    this.duration,
    this.level,
    this.tags,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Course.fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      imageUrl: data['imageUrl'],
      category: data['category'] ?? 'Medical',
      price: data['price'] != null ? (data['price'] as num).toDouble() : null,
      isFeatured: data['isFeatured'] ?? false,
      isApproved: data['isApproved'] ?? true,
      enrollmentCount: data['enrollmentCount'] ?? 0,
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : 0.0,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      instructor: data['instructor'],
      duration: data['duration'],
      level: data['level'],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'imageUrl': imageUrl,
        'category': category,
        'price': price,
        'isFeatured': isFeatured,
        'isApproved': isApproved,
        'enrollmentCount': enrollmentCount,
        'rating': rating,
        'createdAt': createdAt.toIso8601String(),
        'instructor': instructor,
        'duration': duration,
        'level': level,
        'tags': tags ?? [],
      };
}
