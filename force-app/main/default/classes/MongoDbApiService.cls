public class MongoDbApiService {
    
	public abstract class MongoDbConnection {
        public String collection; 
        public String database = 'project-context';
        public String dataSource = 'Cluster0';
	}
    
    public abstract class SearchableDocument {
        @InvocableVariable(label='Text' description='Text' required=true)
        public String text;
        @InvocableVariable(label='Embedding' description='Embedding' required=true)
        public List<Decimal> embedding;
    }

   
    public static String request(String apiMethod, String jsonStringBody) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MongoDb/' + apiMethod);
        req.setMethod('POST');

        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Access-Control-Request-Headers', '*');
		req.setHeader('api-key', '{!$Credential.MongoDb.api_key}');

        /*String requestBody = String.isEmpty(jsonBody) 
            ? '{"collection":"requirements","database":"project-context","dataSource":"Cluster0","projection": {"_id": 1}}'
            : jsonBody;
*/
        req.setBody(jsonStringBody);
  

        HttpResponse response = new Http().send(req);
        
        Assert.isTrue(response.getStatusCode() < 399, 'MongoDB API returned status code ' + response.getStatusCode());
        
        return response.getBody();
    }
}