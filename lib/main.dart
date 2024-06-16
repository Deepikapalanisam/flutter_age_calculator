import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String myAge = '';
  String daysUntilNextBirthday = '';
  String birthDay = '';
  String nextBirthdayDay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Calculator"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Container(
        color: Colors.cyan, // Background color of the app
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your age is',
                style: TextStyle(fontSize: 60, color: Colors.blue[900]), // Text color for "Your age is"
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                myAge,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color of the age display
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                daysUntilNextBirthday,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color for days until next birthday
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                birthDay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color for birth day
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                nextBirthdayDay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color for next birthday day
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () => pickDob(context),
                child: const Text('Pick Date of Birth'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickDob(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      calculateAge(pickedDate);
    }
  }

  void calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    // Calculate days until next birthday
    DateTime nextBirthday = DateTime(now.year, birth.month, birth.day);
    if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
      nextBirthday = DateTime(now.year + 1, birth.month, birth.day);
    }
    int daysUntilBirthday = nextBirthday.difference(now).inDays;

    // Get the day of the week for birth date and next birthday
    String birthDayOfWeek = getDayOfWeek(birth.weekday);
    String nextBirthdayDayOfWeek = getDayOfWeek(nextBirthday.weekday);

    // Format the birth date and next birthday date
    String formattedBirthDate = DateFormat('EEEE, MMMM d, yyyy').format(birth);
    String formattedNextBirthdayDate = DateFormat('EEEE, MMMM d, yyyy').format(nextBirthday);

    setState(() {
      myAge = '$years years, $months months, and $days days';
      daysUntilNextBirthday = 'Days until next birthday: $daysUntilBirthday';
      birthDay = 'You were born on $formattedBirthDate';
      nextBirthdayDay = 'Your next birthday will be on $formattedNextBirthdayDate';
    });
  }

  String getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
