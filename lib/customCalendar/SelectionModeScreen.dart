import 'package:dev_to_codes/customCalendar/CustomCalendarView.dart';
import 'package:dev_to_codes/customCalendar/times_model.dart';
import 'package:flutter/material.dart';

class SelectionModeScreen extends StatelessWidget {
  const SelectionModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, TimesModel> dummyTimeslots = {
      "Monday": TimesModel(
        isOpen: true,
        openTime: "09:00 AM",
        closeTime: "06:00 PM",
      ),
      "Tuesday": TimesModel(
        isOpen: true,
        openTime: "09:00 AM",
        closeTime: "06:00 PM",
      ),
      "Wednesday": TimesModel(
        isOpen: true,
        openTime: "09:00 AM",
        closeTime: "06:00 PM",
      ),
      "Thursday": TimesModel(
        isOpen: true,
        openTime: "09:00 AM",
        closeTime: "06:00 PM",
      ),
      "Friday": TimesModel(
        isOpen: true,
        openTime: "09:00 AM",
        closeTime: "06:00 PM",
      ),
      "Saturday": TimesModel(isOpen: true),
      "Sunday": TimesModel(isOpen: false),
    };

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Selection Mode',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                ((e) => CustomCalendarView(multiDay: false)),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Show Single Day'),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                ((e) => CustomCalendarView(multiDay: true)),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Show Multiple Days'),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                ((e) => CustomCalendarView(
                                  multiDay: true,
                                  timeslots: dummyTimeslots,
                                )),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Show With TimeSlots'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
