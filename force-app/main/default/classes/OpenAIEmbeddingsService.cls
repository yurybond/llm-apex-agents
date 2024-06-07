public class OpenAIEmbeddingsService {
    public class DocumentEmbedding {
        @InvocableVariable(label='Text' description='Text to get embedding' required=true)
        public String document;
        @InvocableVariable(label='Embedding' description='Embedding for the given text returned from OpenAI' required=false)
        public List<Decimal> embedding;
        @InvocableVariable(label='JSON String of embedding' description='Same as Ebedding but in a format of JSON array of strings' required=false)
        public String embeddingJsonArray;
    }
    
    class EmbeddingApiPayloadDTO {
        public String model = 'text-embedding-ada-002';
        public List<String> input;
    }
    
    class EmbeddingResultDTO {
        public String object_x {get;set;}
        public List<Data> data {get;set;}
        public String model {get;set;}
        public Usage usage {get;set;}

    }
    public class Data {
        public String object_x {get;set;}
        public Integer index {get;set;}
        public List<Decimal> embedding {get;set;}
    }
    
    public class Usage {
        public Integer prompt_tokens {get;set;}
        public Integer total_tokens {get;set;}
    }
    
    
    @InvocableMethod(label='Get Embedding From OpenAI' description='Method send a text and return embedding from Open AI' category='Open AI')
    public static List<DocumentEmbedding> getEmbeddings(List<String> documents) {
		List<DocumentEmbedding> docEmbedding = new List<DocumentEmbedding>();
        
        
        EmbeddingApiPayloadDTO requestBody = new EmbeddingApiPayloadDTO();
		requestBody.input = documents;
        
                
        String response = OpenAiApiService.request(
            'embeddings',
            JSON.serialize(requestBody)
        );
        
        //workaround for the keyqord "object" reserved in salesforce
        String respJsonString = response.replaceAll('object', 'object_x');
        
        EmbeddingResultDTO result = (EmbeddingResultDTO) JSON.deserialize(respJsonString, EmbeddingResultDTO.class);
        
        //Just Echo for now
        for (Integer i = 0; i < documents.size(); i++) {
            DocumentEmbedding v  = new DocumentEmbedding();
            v.document = documents[i];
            v.embedding  = result.data[i].embedding;
            v.embeddingJsonArray = JSON.serialize(v.embedding);
			docEmbedding.add(v);
            
        }
        
        return docEmbedding;
    }
    
}