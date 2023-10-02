class MessageModel {
  late final String fromId;
  late final Type type;
  late final String read;
  late final String msg;
  late final String toId;
  late final String sent;

  MessageModel({
    required this.fromId,
    required this.type,
    required this.read,
    required this.msg,
    required this.toId,
    required this.sent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        fromId: json['fromId'].toString(),
        type:
            json['type'].toString() == Type.image.name ? Type.image : Type.text,
        read: json['read'].toString(),
        msg: json['msg'].toString(),
        toId: json['toId'].toString(),
        sent: json['sent'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'toId': toId,
        'msg': msg,
        'sent': sent,
        'fromId': fromId,
        'read': read,
      };
}

enum Type { text, image }
