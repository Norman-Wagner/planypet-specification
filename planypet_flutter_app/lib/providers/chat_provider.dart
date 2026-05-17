import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/deepseek_service.dart';

final deepSeekServiceProvider = Provider<DeepSeekService>((_) => DeepSeekService());

class ChatState {
  ChatState({required this.messages, required this.isLoading, this.error});
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading, String? error}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._service) : super(ChatState(messages: const [], isLoading: false));

  final DeepSeekService _service;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMessage = ChatMessage(role: 'user', content: trimmed);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final reply = await _service.sendMessage(state.messages);
      state = state.copyWith(
        messages: [...state.messages, ChatMessage(role: 'assistant', content: reply)],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = ChatState(messages: const [], isLoading: false);
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref.watch(deepSeekServiceProvider));
});
