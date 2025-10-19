
String convertDateTimeToString(DateTime date ){
  
  String year = date.year.toString();
  String month = date.month.toString();
  String day = date.day.toString();

  if(month.length == 1){
    month = '0$month';
  }

  if(day.length ==1){
    day = '0$day';
  }

  return year +month + day;
}