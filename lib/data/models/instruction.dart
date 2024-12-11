// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:platefulai/data/models/step.dart';

class Instruction {
  List<StepModel> steps;
  String? image;
  String title;
  int timeTaken;

  Instruction({
    required this.steps,
    required this.title,
    this.image,
    required this.timeTaken,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'steps': steps.map((x) => x.toJson()).toList(),
      'image': image,
      'title': title,
      'timeTaken': timeTaken,
    };
  }

  factory Instruction.fromJson(Map<String, dynamic> map) {
    return Instruction(
      steps: List<StepModel>.from(
        (map['steps'] as List).map<StepModel>(
          (x) => StepModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      image: map['image'] == null ? null : map['image'] as String,
      title: map['title'] as String,
      timeTaken: map['timeTaken'] as int,
    );
  }
}
