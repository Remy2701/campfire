import 'package:dart_openai/dart_openai.dart';
import 'package:dmp3s/env.dart';

/// The model to use for the Prompt Generation.
const _model = "gpt-3.5-turbo";

/// The maximum tokens to generate.
const _requestsTimeOut = Duration(seconds: 60);

/// The system to explain the AI Modle its role.
const _systemMessage = "You are a helpful assistant, you must "
    "only give me the prompt!";

/// The base prompt used to generate the prompt.
const _prompt = "Can you generate a prompt that could be used to find "
    "information/solve the following problem, this can be a sub question "
    "related to the problem. Please, don't just reformulate but point out "
    "a path we can take to research the question.";

/// The class responsible to generate the prompts.
class PromptGenerator {
  // Singleton instance of [PromptGenerator].
  static PromptGenerator? _instance;

  /// Get the singleton instance of [PromptGenerator].\
  static PromptGenerator get instance {
    _instance ??= PromptGenerator();
    return _instance!;
  }

  /// Initialize the [PromptGenerator].
  PromptGenerator() {
    OpenAI.apiKey = Env.apiKey;
    OpenAI.requestsTimeOut = _requestsTimeOut;
  }

  /// Generate a prompt for the given [title] and [description].
  Future<String> generate({
    required String title,
    required String description,
  }) async {
    // Create the system message used to explain the its role to the AI Model.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          _systemMessage,
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    // The user message to generate the prompt.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "$_prompt Here is the title of the question: '$title', and here is the decription '$description'.",
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // The request to the AI Model.
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: _model,
      responseFormat: {"type": "text"},
      seed: 6,
      messages: [
        systemMessage,
        userMessage,
      ],
      temperature: 0.2,
      maxTokens: 500,
    );

    /// Retrieve the response.
    return chatCompletion.choices.first.message.content
            ?.map((it) => it.text)
            .join(" / ") ??
        "";
  }
}
