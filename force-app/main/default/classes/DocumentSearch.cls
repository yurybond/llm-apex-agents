public class DocumentSearch {
    @AuraEnabled
    @InvocableVariable(label='Text' description='Text' required=false)
    public String text;
    @AuraEnabled
    @InvocableVariable(label='Id' description='Id' required=false)
    public String documentId;
    @AuraEnabled
    @InvocableVariable(label='Type' description='Type' required=false)
    public String type;
    @AuraEnabled
    @InvocableVariable(label='Score' description='Score' required=false)
    public String score;
}