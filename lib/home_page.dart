import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/feature_box.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAiService openAiService = OpenAiService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

 
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assistant'),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: Column(
        // virtual assistant picture
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/virtualAssistant.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
          // chat bubble
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
              top: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: Radius.zero,
              ),
              border: Border.all(
                color: Pallete.borderColor,
              ),
            ),
            child: const Text(
              'Good Morning, What task can i do for you?',
              style: TextStyle(
                color: Pallete.mainFontColor,
                fontFamily: 'Cera Pro',
                fontSize: 25,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
              top: 10,
              left: 22,
            ),
            child: const Text(
              'Here are a few features',
              style: TextStyle(
                fontFamily: 'Cera pro',
                color: Pallete.mainFontColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Featues list
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText: 'A smarter way to stay organized and informed with ChatGPT',
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-e and ChatGPT',
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async{
          if(await speechToText.hasPermission && speechToText.isNotListening){
            await startListening();
          }else if(speechToText.isListening){
            await openAiService.isArtPromptAPI(lastWords);
            await stopListening();
          }else{
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
