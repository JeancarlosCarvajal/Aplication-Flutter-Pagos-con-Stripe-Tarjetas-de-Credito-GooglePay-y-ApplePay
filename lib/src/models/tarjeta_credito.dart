


// modelo de las tarjetas de cerdio
class TarjetaCredito {
  final String cardNumberHidden;
  final String cardNumber;
  final String brand;
  final String cvv;
  final String expiracyDate;
  final String cardHolderName;

  TarjetaCredito({
    cardNumberHidden,
    cardNumber,
    brand,
    cvv,
    expiracyDate,
    cardHolderName
  }): cardNumberHidden = cardNumberHidden ?? '',
      cardNumber = cardNumber ?? '',
      brand = brand ?? '',
      cvv = cvv ?? '',
      expiracyDate = expiracyDate ?? '',
      cardHolderName = cardHolderName ?? '';
}