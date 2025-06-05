import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/diet_request.dart'; // Make sure the path is correct
import '../models/diet_response.dart'; // Make sure the path is correct

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  DietResponse? _dietResponse;
  bool _isLoading = false;
  String? _errorMessage;

  // Updated request data based on the new curl command
  final DietRequest _requestData = DietRequest(
    heightCm: 175, // Example value, adjust as needed
    weightKg: 75,   // Example value, adjust as needed
    age: 21,      // Example value, adjust as needed
    gender: "female", // Example value, adjust as needed
    goal: "weight_loss", // Example value, adjust as needed
    targetWeight: 65.0, // Example value, adjust as needed
    activityLevel: "sedentery", // Example value, adjust as needed
    allergens: [], // Example values, adjust as needed
    days: 7,      // Example value, adjust as needed
  );

  @override
  void initState() {
    super.initState();
    _fetchDietPlan(); // Automatically request data when the page loads
  }

  Future<void> _fetchDietPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Updated API endpoint
    const String apiUrl = 'http://10.0.2.2:8000/generate-diet'; // Your FastAPI endpoint for diet

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: dietRequestToJson(_requestData),
      );

      if (response.statusCode == 200) {
        // Successful response
        setState(() {
          _dietResponse = dietResponseFromJson(response.body);
        });
      } else {
        // Server error or invalid response
        setState(() {
          _errorMessage =
              'Error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      // Network error (e.g., server unreachable)
      setState(() {
        _errorMessage = 'Could not connect to server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Diet Plan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          'Loading error: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchDietPlan,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _dietResponse == null
                  ? const Center(child: Text('No diet plan available'))
                  : _buildDietPlanDisplay(_dietResponse!),
    );
  }

  Widget _buildDietPlanDisplay(DietResponse response) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Status', response.status, Colors.green),
          _buildInfoCard('BMI Category', response.bmiCase, Colors.blue),
          _buildInfoCard('BFP Category', response.bfpCase, Colors.teal),
          const SizedBox(height: 20),
          const Text(
            'Your diet plan:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...response.dietPlan.map((dayPlan) => _buildDayDietCard(dayPlan)),
          // Keep action buttons at the bottom if they are not part of the API response data
          const SizedBox(height: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayDietCard(DietPlan dayPlan) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${dayPlan.day}: ${dayPlan.dietName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              dayPlan.description,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 20, thickness: 1),
            ...dayPlan.meals.map((meal) => _buildMealTile(meal)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${meal.type}: ${meal.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(meal.description),
          Text('Calories: ${meal.calories.toStringAsFixed(2)} kcal'),
          // if (meal.calories == 0) // Example highlighting for 0 calories, adjust as needed
          //   Text(' (Value 0.00 may show on placeholder)', style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Action buttons remain the same as they are UI elements not directly tied to API data
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCustomButton(
            context,
            'Notes',
            Icons.edit_note,
          ),
          _buildCustomButton(
            context,
            'BMI',
            Icons.calculate,
          ),
          _buildCustomButton(
            context,
            'Log food',
            Icons.add_box,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String text, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            // Action for button
          },
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}