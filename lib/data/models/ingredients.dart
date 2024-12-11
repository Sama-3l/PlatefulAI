// ignore_for_file: public_member_api_docs, sort_constructors_first
class Ingredient {
  String name;
  String quantity;
  bool done;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.done,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String,
      quantity: map['quantity'] as String,
      done: false,
    );
  }
}
