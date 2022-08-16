import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_stripe_card_pay/src/models/models.dart';

part 'pagar_event.dart';
part 'pagar_state.dart';

class PagarBloc extends Bloc<PagarEvent, PagarState> {
  PagarBloc() : super(PagarState(  )) {
    
    on<PagarEvent>((event, emit) {
      // TODO: implement event handler
    });

    // cuando se selcciona una tarjeta
    on<OnSelectedTarjeta>((event, emit) {
      print('jean ene vento: ${event.tarjeta.cardHolderName}');
      emit(state.copyWith( tarjetaActiva: true, tarjeta: event.tarjeta ));
    });

    // cuando se descativa una tarjeta
    on<OnDeactivateTarjeta>((event, emit) =>  emit(state.copyWith( tarjetaActiva: false )));

  }
}
