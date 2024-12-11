part of 'chat_page_update_cubit.dart';

@immutable
sealed class ChatPageUpdateState {}

final class ChatPageUpdateInitial extends ChatPageUpdateState {}

final class ChatUpdate extends ChatPageUpdateState {}

final class WaitingForAI extends ChatPageUpdateState {}
