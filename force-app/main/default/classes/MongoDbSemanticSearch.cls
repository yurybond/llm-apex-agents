public class MongoDbSemanticSearch {
    
    public class SearchCache extends MongoDbApiService.SearchableDocument {
        @InvocableVariable(label='Query' description='Query' required=true)
        public String query;
        @InvocableVariable(label='Embedding' description='Embedding' required=true)
        public List<Decimal> embedding;
    }
    
    public class DocumentSearchResult {
        @AuraEnabled
        @InvocableVariable(label='Documents' description='Documents' required=true)
        public List<DocumentSearch> documents;
    }
   
    static String searchTemplate = '{"$search": {"index": "embedding","knnBeta": {"path":"embedding","k": 50,"vector": []}}}';
    static String project = '{ "$project": {"type":1, "text":1, "score": {"$meta": "searchScore"}}}';
    
    public class SearchRequest extends MongoDbApiService.MongoDbConnection{
        public List<String> pipeline;
    }

    
    @InvocableMethod(label='Semantic Search' description='Get Semantic Search Results' category='MongoDb')
    public static List<DocumentSearchResult> semanticSearch(List<String> searchText) {
        
        /**TODO
         * Request search text from cache
         */
        //get embedding
        List<OpenAIEmbeddingsService.DocumentEmbedding> documentsWithEmbeddings = OpenAIEmbeddingsService.getEmbeddings(searchText);
        
		List<SearchCache> documents = new List<SearchCache>();
        
        for (Integer i=0; i < documentsWithEmbeddings.size(); i++) {
            SearchCache c = new SearchCache();
            c.query = searchText[i];
            c.embedding = documentsWithEmbeddings[i].embedding;
            documents.add(c);
        }

        //insert query to cache
        MongoDbInsertDocumentService.InsertDocument request = new MongoDbInsertDocumentService.InsertDocument();
        request.collection = 'search-cache';
        request.documents = documents;
        String response = MongoDbApiService.request('action/insertMany', JSON.serialize(request));
        
        //search
    	SearchRequest sr = new SearchRequest();
        sr.collection = 'requirements';
        
        String searchWithVector = searchTemplate.replace('"vector": []', '"vector": ' + JSON.serialize(documents[0].embedding));
        //sr.pipeline = new List<String>{searchWithVector,project} ;
        String searchRequestBody = JSON.serialize(sr).replace('"pipeline":null', '"pipeline": [' + searchWithVector + ',' + project + ']' );
            
        String JSONResult = MongoDbApiService.request('action/aggregate', searchRequestBody);
	

        DocumentSearchResult results = (DocumentSearchResult) JSON.deserialize(JSONResult.replaceAll('_id', 'documentId'), DocumentSearchResult.class);
        
        return new List<DocumentSearchResult>{results};
    }
}