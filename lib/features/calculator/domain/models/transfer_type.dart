// we_dont_pay_much/features/calculator/domain/models/fee_calculation_rule.dart

enum TransferType { cardToCard, payaIndividual, payaGroup, satna, pol }

/// Stable codes used by backend API.
extension TransferTypeApi on TransferType {
  String get apiCode {
    switch (this) {
      case TransferType.cardToCard:
        return 'CARD_TO_CARD';
      case TransferType.payaIndividual:
        return 'PAYA_INDIVIDUAL';
      case TransferType.payaGroup:
        return 'PAYA_GROUP';
      case TransferType.satna:
        return 'SATNA';
      case TransferType.pol:
        return 'POL';
    }
  }
}

/// Mapping API → enum
TransferType? transferTypeFromApiCode(String code) {
  switch (code.toUpperCase()) {
    case 'CARD_TO_CARD':
      return TransferType.cardToCard;
    case 'PAYA_INDIVIDUAL':
      return TransferType.payaIndividual;
    case 'PAYA_GROUP':
      return TransferType.payaGroup;
    case 'SATNA':
      return TransferType.satna;
    case 'POL':
      return TransferType.pol;
    default:
      return null;
  }
}
