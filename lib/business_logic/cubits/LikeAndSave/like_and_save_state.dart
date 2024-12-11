part of 'like_and_save_cubit.dart';

@immutable
sealed class LikeAndSaveState {}

final class LikeAndSaveInitial extends LikeAndSaveState {}

final class LikeSaveState extends LikeAndSaveState {}
