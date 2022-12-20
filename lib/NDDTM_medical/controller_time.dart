bool getCheckOpenCloseTimeStatus(String openTime, String closeTime) {
  DateTime now = DateTime.now();
  int nowHour = now.hour;
  int nowMin = now.minute;

  // print('Now: H$nowHour M$nowMin');

  var openTimes = openTime.split(":");
  int openHour = int.parse(openTimes[0]);
  int openMin = int.parse(openTimes[1]);

  // print('OpenTimes: H$openHour M$openMin');

  var closeTimes = closeTime.split(":");
  int closeHour = int.parse(closeTimes[0]);
  int closeMin = int.parse(closeTimes[1]);

  // print('CloseTimes: H$closeHour M$closeMin');

  if (nowHour > openHour && nowHour < closeHour) {
    return true;
  } else if (nowHour == openHour && nowHour == closeHour) {
    if (nowMin >= openMin && nowMin <= closeMin) return true;
    return false;
  } else if (nowHour == openHour) {
    if (nowMin >= openMin) return true;
    return false;
  } else if (nowHour == closeHour) {
    if (nowMin <= closeMin) return true;
    return false;
  }

  return false;
}
