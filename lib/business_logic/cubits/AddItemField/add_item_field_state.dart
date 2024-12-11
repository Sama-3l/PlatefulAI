part of 'add_item_field_cubit.dart';

@immutable
sealed class AddItemFieldState {}

final class AddItemFieldInitial extends AddItemFieldState {}

final class AddItemState extends AddItemFieldState {}
