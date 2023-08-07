import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'active_time_state.dart';

class ActiveTimeCubit extends Cubit<ActiveTimeState> {
  ActiveTimeCubit() : super(ActiveTimeInitial());
}
