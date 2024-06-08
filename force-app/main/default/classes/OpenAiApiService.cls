public class OpenAiApiService {
    private final static String MODEL = Agent_Settings__c.getInstance().LlmMOdel__c;
    public static String request(String apiMethod, String jsonStringBody) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OpenAI/' + apiMethod);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer {!$Credential.OpenAI.API_KEY}');
        request.setMethod('POST');
        request.setTimeout(120000);

        request.setBody(jsonStringBody);        

        HttpResponse response = new Http().send(request);
        
        Assert.isTrue(response.getStatusCode() <= 399, 'OpenAI API returned status code ' + response.getStatusCode());
        
        return response.getBody();
        

    }
}