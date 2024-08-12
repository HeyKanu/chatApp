class Message {
  Message({
    required this.formId,
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
  });
  late  String formId;
  late  String msg;
  late  String read;
  late  String told;
  late  String type;
  late  String sent;
  
  Message.fromJson(Map<String, dynamic> json){
    formId = json['formId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formId'] = formId;
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type;
    data['sent'] = sent;
    return data;
  }
}
// enum Type{text,image}