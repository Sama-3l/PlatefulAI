part of 'update_textfield_cubit.dart';

@immutable
sealed class UpdateTextfieldState {}

final class UpdateTextfieldInitial extends UpdateTextfieldState {}

final class UpdateState extends UpdateTextfieldState {}
