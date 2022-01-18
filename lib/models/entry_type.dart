enum entryTypeEnum { income, expense }

extension ParseToString on entryTypeEnum {
  String toShortString() {
    return toString().split('.').last;
  }
}

entryTypeEnum entryTypeFromString(String value) {
  switch (value) {
    case "Income":
      return entryTypeEnum.income;
    default:
      return entryTypeEnum.expense;
  }
}
