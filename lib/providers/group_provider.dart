import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group_model.dart';
import '../services/group_service.dart';

/// Estado para el manejo de grupos
class GroupState {
  final GroupModel? currentGroup;
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> members;
  final bool isJoining;
  final bool isLeaving;

  const GroupState({
    this.currentGroup,
    this.isLoading = false,
    this.error,
    this.members = const [],
    this.isJoining = false,
    this.isLeaving = false,
  });

  GroupState copyWith({
    GroupModel? currentGroup,
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? members,
    bool? isJoining,
    bool? isLeaving,
  }) {
    return GroupState(
      currentGroup: currentGroup ?? this.currentGroup,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      members: members ?? this.members,
      isJoining: isJoining ?? this.isJoining,
      isLeaving: isLeaving ?? this.isLeaving,
    );
  }
}

/// Notifier para el manejo de grupos
class GroupNotifier extends StateNotifier<GroupState> {
  GroupNotifier() : super(const GroupState()) {
    loadCurrentGroup();
  }

  /// Cargar el grupo actual del conductor
  Future<void> loadCurrentGroup() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('🔍 GROUP_PROVIDER: Loading current group...');
      
      final group = await GroupService.getMyGroup();
      
      print('🔍 GROUP_PROVIDER: Group loaded: ${group?.code}');
      state = state.copyWith(
        currentGroup: group,
        isLoading: false,
      );
    } catch (e) {
      print('❌ GROUP_PROVIDER: Error loading group: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Unirse a un grupo
  Future<bool> joinGroup(String groupCode) async {
    state = state.copyWith(isJoining: true, error: null);
    try {
      print('🔗 GROUP_PROVIDER: Joining group with code: $groupCode');
      
      final success = await GroupService.joinGroup(groupCode);
      
      if (success) {
        // Recargar el grupo actual después de unirse
        await loadCurrentGroup();
        state = state.copyWith(isJoining: false);
        return true;
      } else {
        state = state.copyWith(
          error: 'No se pudo unir al grupo',
          isJoining: false,
        );
        return false;
      }
    } catch (e) {
      print('❌ GROUP_PROVIDER: Error joining group: $e');
      state = state.copyWith(
        error: e.toString(),
        isJoining: false,
      );
      return false;
    }
  }

  /// Salir del grupo actual
  Future<bool> leaveGroup() async {
    state = state.copyWith(isLeaving: true, error: null);
    try {
      print('🚪 GROUP_PROVIDER: Leaving current group...');
      
      final success = await GroupService.leaveGroup();
      
      if (success) {
        // Limpiar completamente el estado después de salir
        state = const GroupState(
          currentGroup: null,
          members: [],
          isLeaving: false,
          isLoading: false,
          error: null,
          isJoining: false,
        );
        print('✅ GROUP_PROVIDER: Successfully left group, state cleared');
        return true;
      } else {
        state = state.copyWith(
          error: 'No se pudo salir del grupo',
          isLeaving: false,
        );
        return false;
      }
    } catch (e) {
      print('❌ GROUP_PROVIDER: Error leaving group: $e');
      state = state.copyWith(
        error: e.toString(),
        isLeaving: false,
      );
      return false;
    }
  }

  /// Cargar los miembros del grupo
  Future<void> loadGroupMembers() async {
    if (state.currentGroup == null) {
      return; // No hay grupo para cargar miembros
    }

    try {
      print('👥 GROUP_PROVIDER: Loading group members...');
      
      final members = await GroupService.getGroupMembers();
      
      print('👥 GROUP_PROVIDER: Members loaded: ${members.length}');
      state = state.copyWith(members: members);
    } catch (e) {
      print('❌ GROUP_PROVIDER: Error loading members: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Limpiar completamente el estado
  void clearState() {
    state = const GroupState(
      currentGroup: null,
      members: [],
      isLoading: false,
      error: null,
      isJoining: false,
      isLeaving: false,
    );
    print('🧹 GROUP_PROVIDER: State cleared completely');
  }

  /// Refrescar datos
  Future<void> refresh() async {
    await loadCurrentGroup();
    if (state.currentGroup != null) {
      await loadGroupMembers();
    }
  }
}

/// Provider para el notifier de grupos
final groupProvider = StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier();
});

/// Provider para verificar si el usuario tiene grupo
final hasGroupProvider = Provider<bool>((ref) {
  final groupState = ref.watch(groupProvider);
  return groupState.currentGroup != null;
});

/// Provider para el grupo actual
final currentGroupProvider = Provider<GroupModel?>((ref) {
  final groupState = ref.watch(groupProvider);
  return groupState.currentGroup;
});

/// Provider para los miembros del grupo
final groupMembersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final groupState = ref.watch(groupProvider);
  return groupState.members;
});

/// Provider para el estado de carga de grupos
final groupLoadingProvider = Provider<bool>((ref) {
  final groupState = ref.watch(groupProvider);
  return groupState.isLoading;
});

/// Provider para errores de grupos
final groupErrorProvider = Provider<String?>((ref) {
  final groupState = ref.watch(groupProvider);
  return groupState.error;
});