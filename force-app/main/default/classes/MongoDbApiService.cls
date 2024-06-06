public class MongoDbApiService {
    public static String sendRequest(String jsonBody) {


        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MongoDb/action/findOne');
        req.setMethod('POST');

        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Access-Control-Request-Headers', '*');
		req.setHeader('api-key', '{!$Credential.MongoDb.api_key}');

        String requestBody = String.isEmpty(jsonBody) 
            ? '{"collection":"requirements","database":"project-context","dataSource":"Cluster0","projection": {"_id": 1}}'
            : jsonBody;
        req.setBody(requestBody);

        HttpResponse res = new Http().send(req);
		
        return res.getBody();
        
    }
}