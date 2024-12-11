// ignore_for_file: public_member_api_docs, sort_constructors_first
class StepModel {
  String step;
  bool done;

  StepModel({required this.step, required this.done});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'step': step,
    };
  }

  factory StepModel.fromJson(Map<String, dynamic> map) {
    return StepModel(
      step: map['step'] as String,
      done: false,
    );
  }
}
