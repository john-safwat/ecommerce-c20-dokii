import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<S, A, NE> extends Cubit<S> {
  BaseCubit(super.initialState);

  Future<void> doAction(A action);

  final StreamController<NE> _navController = StreamController.broadcast();

  Stream<NE> get navStream => _navController.stream;

  void emitNavigation(NE event) {
    _navController.add(event);
  }

  @override
  Future<void> close() {
    _navController.close();
    return super.close();
  }
}
