class User {
  final String id;
  final String name;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    this.isOnline = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isOnline': isOnline,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        isOnline: json['isOnline'] ?? false,
      );

  User copyWith({
    String? id,
    String? name,
    bool? isOnline,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

