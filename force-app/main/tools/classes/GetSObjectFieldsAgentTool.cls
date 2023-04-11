//Written by Charlie Jonas & GPT-4
public class GetSObjectFieldsAgentTool implements IAgentTool {
  public string getDescription() {
    return 'Get fields metadata for a SObject';
  }

  public Map<string, string> getParameters() {
    return new Map<string, string>{ 'sobject' => 'API Name of the SObject' };
  }

  public string execute(Map<string, string> args) {
    String sobType = args.get('sobject');
    SObjectType describeType = Schema.getGlobalDescribe().get(sobType);
    if (describeType == null) {
      return 'SObject not found for ' + sobType + '.';
    }
    Map<String, Schema.SObjectField> mfields = describeType.getDescribe()
      .fields.getMap();
    String[] fields = new List<String>{};
    for (String key : mfields.keySet()) {
      Schema.DescribeFieldResult field = mfields.get(key).getDescribe();
      fields.add(
        String.format(
          '{0}: {1}',
          new List<String>{ field.getName(), field.getType().name() }
        )
      );
    }
    return JSON.serialize(fields);
  }
}