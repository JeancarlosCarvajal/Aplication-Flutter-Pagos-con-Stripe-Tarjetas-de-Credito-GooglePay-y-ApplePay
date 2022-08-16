part of 'pagar_bloc.dart';

abstract class PagarEvent extends Equatable {
  const PagarEvent();
  @override
  List<Object> get props => [];
}


class OnSelectedTarjeta extends PagarEvent {
  final TarjetaCredito tarjeta;
  const OnSelectedTarjeta(this.tarjeta);
}

class OnDeactivateTarjeta extends PagarEvent {}