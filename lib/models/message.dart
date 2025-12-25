class Message {
  final String text;
  final bool isSender;
  final DateTime timestamp;
  final String userId;

  Message({
    required this.text,
    required this.isSender,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isSender': isSender,
        'timestamp': timestamp.toIso8601String(),
        'userId': userId,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        text: json['text'],
        isSender: json['isSender'],
        timestamp: DateTime.parse(json['timestamp']),
        userId: json['userId'],
      );

  Message copyWith({
    String? text,
    bool? isSender,
    DateTime? timestamp,
    String? userId,
  }) {
    return Message(
      text: text ?? this.text,
      isSender: isSender ?? this.isSender,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
    );
  }
}

