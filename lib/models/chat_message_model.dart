class ChatMessageModel {
  final String id;
  final String from; // 'customer' or 'admin'
  final String text;
  final String time;

  ChatMessageModel({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
  });

  bool get isCustomer => from == 'customer';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      from: json['from'] ?? 'customer',
      text: json['text'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'text': text,
      'time': time,
    };
  }
}
