import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {
  final String apiUrl = 'https://api.jsonserve.com/Uw5CrX';

  /*Future<List<dynamic>> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }*/



  Future<List<dynamic>> fetchQuizData() async {
  try {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
  final decodedData = json.decode(response.body);
  // Extract the 'questions' field from the response
  if (decodedData != null && decodedData['questions'] != null) {
  return decodedData['questions']; // Return only the questions array
  } else {
  throw Exception('Invalid API response: Missing "questions" field.');
  }
  } else {
  throw Exception('Failed to load quiz data. Status code: ${response.statusCode}');
  }
  } catch (e) {
  throw Exception('Error: $e');
  }
  }






}
