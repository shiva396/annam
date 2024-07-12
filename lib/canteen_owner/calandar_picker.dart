import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CalandarPicker extends StatefulWidget {
  const CalandarPicker({super.key});

  @override
  State<CalandarPicker> createState() => _CalandarPickerState();
}

class _CalandarPickerState extends State<CalandarPicker> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [DateTime.now()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSingleDatePickerWithValue();
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Widget _buildSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 80,
      dayMaxWidth: 38,
      animateToDisplayedMonthDate: true,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      centerAlignModePicker: true,
      useAbbrLabelForMonthModePicker: true,
      modePickerTextHandler: ({required monthDate, isMonthPicker}) {
        if (isMonthPicker ?? false) {
          // Custom month picker text
          return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)} C';
        }

        return null;
      },
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      // selectableDayPredicate: (day) =>
      //     !day
      //         .difference(DateTime.now().add(const Duration(days: 3)))
      //         .isNegative &&
      //     day.isBefore(DateTime.now().add(const Duration(days: 30))),
    );
    return SizedBox(
      width: 900,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 800,
            child: CalendarDatePicker2(
              displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
              config: config,
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (dates) => setState(
                  () => _singleDatePickerValueWithDefaultValue = dates),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selected Date :  ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _getValueText(
                  config.calendarType,
                  _singleDatePickerValueWithDefaultValue,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
