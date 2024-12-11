// ignore_for_file: public_member_api_docs, sort_constructors_first
class Tool {
  String name;
  String use;
  bool done;

  Tool({
    required this.name,
    required this.use,
    required this.done,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'use': use,
    };
  }

  factory Tool.fromJson(Map<String, dynamic> map) {
    return Tool(
      name: map['name'] as String,
      use: map['use'] as String,
      done: false,
    );
  }
}
