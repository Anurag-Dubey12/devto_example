import 'package:dev_to_codes/customCalendar/times_model.dart';
import 'package:dev_to_codes/customCalendar/primary_button.dart';
import 'package:flutter/material.dart';

class CustomCalendarView extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Function(DateTime?, DateTime?)? onDateSelected;
  final bool multiDay;
  final Color primaryColor;
  final Color backgroundColor;
  final Map<String, TimesModel>? timeslots;

  const CustomCalendarView({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    this.multiDay = false,
    this.primaryColor = const Color(0xFF5A9FE2),
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.timeslots,
  });

  @override
  CustomCalendarViewState createState() => CustomCalendarViewState();
}

class CustomCalendarViewState extends State<CustomCalendarView> {
  late DateTime _currentDate;
  DateTime? _startDate;
  DateTime? _endDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToMonth(_currentDate);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMonth(DateTime date) {
    int monthOffset =
        (date.year - _currentDate.year) * 12 +
        (date.month - _currentDate.month);
    if (monthOffset >= 0 && monthOffset < 12) {
      double offset = monthOffset * 360;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  String _getWeekdayName(DateTime date) {
    const weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdayNames[date.weekday - 1];
  }

  bool _isVenueOpen(DateTime date) {
    if (widget.timeslots == null) return true;

    final dayName = _getWeekdayName(date);
    final businessHour = widget.timeslots![dayName];

    return businessHour?.isOpen ?? true;
  }
  bool _isVenueClosed(DateTime date) {
    return !_isVenueOpen(date);
  }

  List<DateTime> _getClosedDaysInRange(DateTime start, DateTime end) {
    List<DateTime> closedDays = [];
    DateTime current = start;

    while (current.isBefore(end.add(Duration(days: 1)))) {
      if (_isVenueClosed(current)) {
        closedDays.add(current);
      }
      current = current.add(Duration(days: 1));
    }

    return closedDays;
  }

  void _showClosedDaysSnackbar(List<DateTime> closedDays) {
    if (closedDays.isEmpty) return;

    String message;
    String daysList;

    if (closedDays.length == 1) {
      final day = closedDays.first;
      final dayName = _getWeekdayName(day);
      daysList = '$dayName (${day.day}/${day.month})';
      message = 'The venue is closed on $daysList';
    } else {
      daysList = closedDays
          .map((day) {
            final dayName = _getWeekdayName(day);
            return '$dayName (${day.day}/${day.month})';
          })
          .join(', ');
      message = 'The venue is closed on the following days: $daysList';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSingleClosedDaySnackbar(DateTime date) {
    final dayName = _getWeekdayName(date);

    final message =
        'The venue is closed on $dayName (${date.day}/${date.month}/${date.year})\nPlease select a date when the venue is open for booking.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<String> get _monthNames => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<String> get _dayNames => ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  int _getBusinessDaysInRange(DateTime start, DateTime end) {
    int businessDays = 0;
    DateTime current = start;

    while (current.isBefore(end.add(const Duration(days: 1)))) {
      if (_isVenueOpen(current)) {
        businessDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return businessDays;
  }

  Widget _buildHeader() {
    String headerText;
    if (widget.multiDay) {
      if (_startDate != null && _endDate != null) {
        int totalDays = _endDate!.difference(_startDate!).inDays + 1;
        int businessDays = _getBusinessDaysInRange(_startDate!, _endDate!);
        headerText = '$totalDays days ($businessDays Open days)';
      } else {
        headerText = 'Select dates';
      }
    } else {
      headerText = _startDate != null ? 'Selected date' : 'Select date';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              headerText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget daysOfWeekHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            _dayNames
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget monthCalendarSection(DateTime monthDate) {
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final lastDayOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    List<Widget> dayWidgets = [];

    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(monthDate.year, monthDate.month, day);
      final isSelected = _isDateSelected(date);
      final isInRange = _isDateInRange(date);
      final isRangeStart = _isRangeStart(date);
      final isRangeEnd = _isRangeEnd(date);
      final isToday = _isSameDay(date, DateTime.now());
      final isEnabled = _isDateEnabled(date);
      final isVenueClosed = _isVenueClosed(date);

      dayWidgets.add(
        GestureDetector(
          onTap: isEnabled ? () => _selectDate(date) : null,
          child: Container(
            height: 44,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: _getDateBackgroundColor(
                date,
                isSelected,
                isInRange,
                isRangeStart,
                isRangeEnd,
                isVenueClosed,
              ),
              borderRadius: _getDateBorderRadius(
                date,
                isRangeStart,
                isRangeEnd,
                isInRange,
              ),
              border: _getDateBorder(
                date,
                isSelected,
                isInRange,
                isRangeStart,
                isRangeEnd,
                isVenueClosed,
              ),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getDateCircleColor(
                    isRangeStart,
                    isRangeEnd,
                    isVenueClosed,
                    isSelected,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: _getDateTextColor(
                        date,
                        isSelected,
                        isInRange,
                        isRangeStart,
                        isRangeEnd,
                        isToday,
                        isEnabled,
                        isVenueClosed,
                      ),
                      fontSize: 16,
                      fontWeight:
                          (isRangeStart ||
                                  isRangeEnd ||
                                  (!widget.multiDay && isSelected) ||
                                  isToday)
                              ? FontWeight.w600
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            '${_monthNames[monthDate.month - 1]} ${monthDate.year}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: dayWidgets,
          ),
        ),
      ],
    );
  }

  Border? _getDateBorder(
    DateTime date,
    bool isSelected,
    bool isInRange,
    bool isRangeStart,
    bool isRangeEnd,
    bool isVenueClosed,
  ) {
    if (isVenueClosed && !isSelected && !isInRange) {
      return Border.all(color: Colors.red.withValues(alpha: 0.6), width: 1.5);
    }
    return null;
  }

  Color _getDateBackgroundColor(
    DateTime date,
    bool isSelected,
    bool isInRange,
    bool isRangeStart,
    bool isRangeEnd,
    bool isVenueClosed,
  ) {
    if (widget.multiDay && isInRange && !isVenueClosed) {
      return widget.primaryColor.withValues(alpha: .2);
    }

    return Colors.transparent;
  }

  Color _getDateCircleColor(
    bool isRangeStart,
    bool isRangeEnd,
    bool isVenueClosed,
    bool isSelected,
  ) {
    if ((isRangeStart || isRangeEnd) && !isVenueClosed) {
      return widget.primaryColor;
    }
    if ((isRangeStart || isRangeEnd) && isVenueClosed) {
      return Colors.red.withValues(alpha: 0.8);
    }
    return Colors.transparent;
  }

  BorderRadius _getDateBorderRadius(
    DateTime date,
    bool isRangeStart,
    bool isRangeEnd,
    bool isInRange,
  ) {
    if (!widget.multiDay) return BorderRadius.circular(22);

    if (isRangeStart && isRangeEnd) {
      return BorderRadius.circular(22);
    } else if (isRangeStart) {
      return const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
      );
    } else if (isRangeEnd) {
      return const BorderRadius.only(
        topRight: Radius.circular(22),
        bottomRight: Radius.circular(22),
      );
    } else if (isInRange) {
      return BorderRadius.zero;
    }

    return BorderRadius.circular(22);
  }

  Color _getDateTextColor(
    DateTime date,
    bool isSelected,
    bool isInRange,
    bool isRangeStart,
    bool isRangeEnd,
    bool isToday,
    bool isEnabled,
    bool isVenueClosed,
  ) {
    if (isRangeStart || isRangeEnd || (!widget.multiDay && isSelected)) {
      return Colors.white;
    }
    if (isToday && !isVenueClosed) return widget.primaryColor;
    if (isToday && isVenueClosed) return Colors.red;
    if (!isEnabled) return Colors.white30;
    if (isVenueClosed) return Colors.red.withValues(alpha: 0.9);
    return Colors.white;
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (widget.multiDay) {
        if (_startDate == null || (_startDate != null && _endDate != null)) {
          _startDate = date;
          _endDate = null;
        } else if (_startDate != null && _endDate == null) {
          if (date.isBefore(_startDate!)) {
            _endDate = _startDate;
            _startDate = date;
          } else {
            _endDate = date;
          }

          final closedDays = _getClosedDaysInRange(_startDate!, _endDate!);
          if (closedDays.isNotEmpty) {
            _showClosedDaysSnackbar(closedDays);
          }
        }
      } else {
        if (_isVenueClosed(date)) {
          _showSingleClosedDaySnackbar(date);
          return;
        }
        _startDate = date;
        _endDate = null;
      }
    });
  }

  bool _isDateSelected(DateTime date) =>
      _isSameDay(date, _startDate) || _isSameDay(date, _endDate);

  bool _isDateInRange(DateTime date) {
    if (!widget.multiDay || _startDate == null || _endDate == null) {
      return false;
    }
    return date.isAfter(_startDate!) && date.isBefore(_endDate!);
  }

  bool _isRangeStart(DateTime date) =>
      _startDate != null && _isSameDay(date, _startDate!);

  bool _isRangeEnd(DateTime date) =>
      _endDate != null && _isSameDay(date, _endDate!);

  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isDateEnabled(DateTime date) {
    final today = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (dateOnly.isBefore(todayOnly)) {
      return false;
    }

    if (widget.minDate != null) {
      final minDateOnly = DateTime(
        widget.minDate!.year,
        widget.minDate!.month,
        widget.minDate!.day,
      );
      if (dateOnly.isBefore(minDateOnly)) return false;
    }
    if (widget.maxDate != null) {
      final maxDateOnly = DateTime(
        widget.maxDate!.year,
        widget.maxDate!.month,
        widget.maxDate!.day,
      );
      if (dateOnly.isAfter(maxDateOnly)) return false;
    }

    if (_isVenueClosed(date)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelection =
        _startDate != null && (widget.multiDay || _startDate != null);
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            daysOfWeekHeaderSection(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                cacheExtent: 2000,
                itemCount: widget.multiDay ? 4 : 1,
                itemBuilder: (context, index) {
                  final monthDate = DateTime(
                    _currentDate.year,
                    _currentDate.month + index,
                    1,
                  );
                  return monthCalendarSection(monthDate);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: hasSelection ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 200),
                  child: PrimaryButton(
                    color: hasSelection ? Colors.deepPurpleAccent : Colors.grey,
                    title: widget.multiDay ? 'CONFIRM DATES' : 'CONFIRM DATE',
                    onTap: () {
                      if (hasSelection) {
                        debugPrint(
                          'The date Selected are :$_startDate and $_endDate',
                        );
                        if (widget.multiDay &&
                            _startDate != null &&
                            _endDate != null) {
                          int businessDays = _getBusinessDaysInRange(
                            _startDate!,
                            _endDate!,
                          );
                          debugPrint('Business days in range: $businessDays');
                        }
                        widget.onDateSelected?.call(_startDate, _endDate);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
