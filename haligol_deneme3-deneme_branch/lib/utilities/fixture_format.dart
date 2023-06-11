import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FixtureFormat {

  static const locale = "tr_TR";

  static String getGameTimestamp( Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    DateFormat formatter;

    if( now.year - date.year >= 1){
      formatter = DateFormat("d MMMM y", locale);
      return formatter.format(date);
    } else if ( now.month - date.month >= 1) {
      formatter = DateFormat("d MMMM", locale);
      return formatter.format(date);
    } else if ( now.day - date.day >= 1) {
      return (now.day - date.day).toString() + " gün önce";
    } else if ( now.hour - date.hour >= 1) {
      return (now.hour - date.hour).toString() + " saat önce";
    } else if ( now.minute - date.minute >= 1) {
      return (now.minute - date.minute).toString() + " dakika önce";
    } else {
      return (now.second - date.second).toString() + " saniye önce";
    }

  }

  static String getGameDate( DateTime date){
    final now = DateTime.now();

    if( now.isAfter(date)){
      DateFormat formatter;
      if( now.year - date.year >= 1){
        formatter = DateFormat("d MMMM y", locale);
        return formatter.format(date);
      } else if ( now.month - date.month >= 1) {
        formatter = DateFormat("d MMMM", locale);
        return formatter.format(date);
      } else if ( now.day - date.day >= 1) {
        return (now.day - date.day).toString() + " gün önce";
      } else if ( now.hour - date.hour >= 1) {
        return (now.hour - date.hour).toString() + " saat önce";
      } else if ( now.minute - date.minute >= 1) {
        return (now.minute - date.minute).toString() + " dakika önce";
      } else {
        return (now.second - date.second).toString() + " saniye önce";
      }

    } else {
      DateFormat formatter;
      if( date.year - now.year >= 1){
        formatter = DateFormat("d MMMM y", locale);
        return formatter.format(date);
      } else if ( date.month - now.month >= 1) {
        formatter = DateFormat("d MMMM", locale);
        return formatter.format(date);
      } else if ( date.day - now.day >= 1) {
        return (date.day - now.day).toString() + " gün sonra";
      } else if ( date.hour - now.hour >= 1) {
        return (date.hour - now.hour).toString() + " saat sonra";
      } else if ( date.minute - now.minute >= 1) {
        return (date.minute - now.minute).toString() + " dakika sonra";
      } else {
        return (date.second - now.second).toString() + " saniye sonra";
      }

    }

  }

}