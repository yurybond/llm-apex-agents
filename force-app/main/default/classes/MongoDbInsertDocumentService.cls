public class MongoDbInsertDocumentService {
    
    /** Example:

        List<MongoDbInsertDocumentService.RequirementDocument> documents = new List<MongoDbInsertDocumentService.RequirementDocument>();
        MongoDbInsertDocumentService.RequirementDocument rd = new MongoDbInsertDocumentService.RequirementDocument();
        rd.type = 'test type';
        rd.text = 'tatata dadada';
        rd.embedding = new List<Decimal>{1,2,3};
        documents.add(
            rd
        );
        MongoDbInsertDocumentService.insertRequirementDocuments(documents);

	*/

    public class RequirementDocument extends MongoDbApiService.SearchableDocument {
        @InvocableVariable(label='Text' description='Text' required=true)
        public String text;
        @InvocableVariable(label='Embedding' description='Embedding' required=true)
        public List<Decimal> embedding;
        @InvocableVariable(label='Type' description='Type' required=true)
        public String type;
    }
    
    public class InsertDocument extends MongoDbApiService.MongoDbConnection {
        @InvocableVariable(label='Requirement documents with embeddings' description='Requirement documents with embeddings for semantic search' required=true)
        public List<MongoDbApiService.SearchableDocument> documents;
    }
    
    @InvocableMethod(label='Insert Document to MongoDB' description='Insert Document into requirements collection with embedding' category='MongoDb')
    public static void insertRequirementDocuments(List<RequirementDocument> documents) {

        InsertDocument request = new InsertDocument();
        request.collection = 'requirements';
        request.documents = documents;
        

		String response = MongoDbApiService.request('action/insertMany', JSON.serialize(request));
    }
}