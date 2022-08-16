


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
  }): cardNumberHidden = cardNumberHidden ?? '000',
      cardNumber = cardNumber ?? '000000000000',
      brand = brand ?? 'brand',
      cvv = cvv ?? '000',
      expiracyDate = expiracyDate ?? '0/0',
      cardHolderName = cardHolderName ?? 'xxx';
}