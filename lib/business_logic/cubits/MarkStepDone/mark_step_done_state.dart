part of 'mark_step_done_cubit.dart';

@immutable
sealed class MarkStepDoneState {}

final class MarkStepDoneInitial extends MarkStepDoneState {}

final class MarkDoneState extends MarkStepDoneState {}
