import 'package:date_format/date_format.dart';

String returnsFormattedDate(DateTime data) {
  return formatDate(data, [dd, '/', mm, '/', yyyy]);
}

String returnsDateFormattedWithTime(DateTime data) {
  return formatDate(data, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn, ':', ss]);
}

String returnsFormattedDateAPI(DateTime data) {
  return formatDate(data, [yyyy, '-', mm, '-', dd]);
}
