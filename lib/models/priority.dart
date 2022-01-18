enum PriorityEnum { low, medium, high }

extension ParseToString on PriorityEnum {
  String toShortString() {
    return toString().split('.').last;
  }
}

PriorityEnum priorityFromString(String value) {
  switch (value) {
    case "High":
      return PriorityEnum.high;
    case "Low":
      return PriorityEnum.low;
    default:
      return PriorityEnum.medium;
  }
}
