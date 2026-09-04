import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // IMPORTANT: Replace with your actual Gemini API Key from Google AI Studio
  static const String _apiKey = 'AQ.Ab8RN6JSC5x6TSCrrBET3B13iqiizwduT1ZkjO-SclhtzqQOqA';
  
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
    systemInstruction: Content.system(
      'You are the official Dynetix AI Assistant for Dynetix Software Company. '
      'Dynetix offers premium services: 3D Modeling, Web Development, SEO, and Graphic Design. '
      'Dynetix also offers professional courses: AI (Python), Data Analytics, and Business Strategy. '
      'Be professional, elite, and helpful. Always encourage users to check the "Services" or "Skills" tabs. '
      'For payments, mention that we accept EasyPaisa, JazzCash, and HBL (details are in the Payments tab). '
      'If you dont know something, ask the user to contact human support via the Chat tab.'
    ),
  );

  static Future<String> getResponse(String prompt) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return "AI Key not configured. Please add your Gemini API key in ai_service.dart";
    }

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm sorry, I couldn't generate a response.";
    } catch (e) {
      print('AI Service Error: $e'); // Detailed error for debugging
      return "Error: Unable to connect to AI server. Please try again later.";
    }
  }
}
