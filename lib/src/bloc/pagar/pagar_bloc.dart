import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_stripe_card_pay/src/models/models.dart';

part 'pagar_event.dart';
part 'pagar_state.dart';

class PagarBloc extends Bloc<PagarEvent, PagarState> {
  PagarBloc() : super(PagarState()) {

    // cuando se selcciona una tarjeta
    on<OnSelectedTarjeta>((event, emit) =>  state.copyWith( tarjetaActiva: true, tarjeta: event.tarjeta ));
    // cuando se descativa una tarjeta
    on<OnDeactivateTarjeta>((event, emit) =>  state.copyWith( tarjetaActiva: false ));

  }
}
