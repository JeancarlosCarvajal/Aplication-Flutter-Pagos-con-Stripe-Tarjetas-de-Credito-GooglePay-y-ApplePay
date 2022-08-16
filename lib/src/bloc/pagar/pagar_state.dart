part of 'pagar_bloc.dart';

class PagarState extends Equatable {

  // monto pagar
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;

  // hacer getter para obtener el monto en el formato requerido por stripe
  // en stripe se debe manejar sin comas ni puntos.. ejm. 250.55 = 25055
  String get montoPagarString => '${(montoPagar*100).floor()}';

  // aqui el constructor
  PagarState({
    montoPagar, 
    moneda, 
    bool? tarjetaActiva, 
    TarjetaCredito? tarjeta
  }): montoPagar = 375.5,
      moneda = 'usd',
      tarjetaActiva = tarjetaActiva ?? false,
      tarjeta = tarjeta ?? TarjetaCredito(); // CSM me tenia 1 hora buscado a solucion pendiente que debe tener el condicional ?? sino el valor que le agrege no se cargara

  // hacemos un copywith
  PagarState copyWith({
    double? montoPagar,
    String? moneda,
    bool? tarjetaActiva,
    TarjetaCredito? tarjeta,
  }) => PagarState(
    montoPagar    : montoPagar ?? this.montoPagar,
    moneda        : moneda ?? this.moneda,
    tarjetaActiva : tarjetaActiva ?? this.tarjetaActiva,
    tarjeta       : tarjeta ?? this.tarjeta,
  );
  
  @override
  List<Object> get props => [ montoPagar, moneda, tarjetaActiva, tarjeta ];
} 
