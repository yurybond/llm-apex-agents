public class OpenAIChatModel implements ChatModel.I {

  private string apiKey;
  public string model = Agent_Settings__c.getInstance().LlmMOdel__c; // 'gpt-4' | 'gpt-3.5-turbo'
  public Decimal tempature = 0.0;
  public Integer maxTokens = 2000;
  public string namedCrediential = 'OpenAI';

  public String chat(ChatModel.Message[] messages) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();

    request.setEndpoint('callout:' + namedCrediential + '/chat/completions');
    request.setHeader('Content-Type', 'application/json');
    request.setHeader('Authorization', 'Bearer {!$Credential.OpenAI.API_KEY}');
    request.setMethod('POST');
    request.setTimeout(120000);

    ChatAPIRequest requestBody = new ChatAPIRequest();
    requestBody.messages = messages;
    requestBody.model = model;
    requestBody.temperature = tempature;
    requestBody.max_tokens = maxTokens; // TODO dynamicly set this by calculating tokens
    requestBody.stream = false;

    request.setBody(JSON.serialize(requestBody, true));

    HttpResponse response = http.send(request);

    // if(response.getStatusCode() == 429) {
    //retry?
    // }

    if (response.getStatusCode() == 200) {
      ChatAPICompletion results = (ChatAPICompletion) JSON.deserialize(
        response.getBody(),
        ChatAPICompletion.class
      );

      OpenAIChatModel.Choice completion = results.choices[0];
      return completion.message?.content?.trim();
    } else {
      system.debug(response.getBody());
      throw new OpenAIException(
        'OpenAI API returned status code ' + response.getStatusCode()
      );
    }
  }

  public class OpenAIException extends Exception {
  }

  public class ChatAPIRequest {
    public List<ChatModel.Message> messages;
    public Decimal temperature;
    public Integer max_tokens;
    public Decimal top_p;
    public Decimal frequency_penalty;
    public Decimal presence_penalty;
    public String model;
    public Boolean stream;
    public String parentId;
  }

  public class ChatAPICompletion {
    public String id;
    // public String object;
    public Long created;
    public String model;
    public Usage usage;
    public List<Choice> choices;
  }

  public class Usage {
    public Integer prompt_tokens;
    public Integer completion_tokens;
    public Integer total_tokens;
  }

  public class Choice {
    public ChatModel.Message message;
    public String finish_reason;
    public Integer index;
  }
}
