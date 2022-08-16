part of 'pagar_bloc.dart';

class PagarState extends Equatable {

  // monto pagar
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;


  // aqui el constructor
  PagarState({
    montoPagar, 
    moneda, 
    bool? tarjetaActiva, 
    TarjetaCredito? tarjeta
  }): montoPagar = 375.5,
      moneda = 'USD',
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
