public with sharing class ObjectController {
    public ObjectController() {

    }

    Public string selectedObj{get;set;}

    @AuraEnabled
    Public static List<String> getObjList(){
        List<Schema.SObjectType> objList = Schema.getGlobalDescribe().Values();     
        List<String> objNames = new List<String>();
        // objNames.add(new SelectOption('','-- Select --'));
        for(Schema.SObjectType obj : objList)
        {
            objNames.add(obj.getDescribe().getName());
        }
        objNames.sort();
        return objNames;
    }

    @AuraEnabled
    public static List<string> getFields(String selectedObject){
        List<String> reqFields = new List<String>();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(selectedObject);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        
        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            System.debug('field-->'+field);
            System.debug('F-->'+F.getType()); //type of field
	        reqFields.add(String.valueof(field));
        }
        System.debug(reqFields);
        return reqFields;
    }

    @AuraEnabled
    public static List<sObject> getRecordsData(String selectedObject,List<String> selectedFields){
        List<sObject> lstObject = new List<sObject>();
        String fields = '';
        for (Integer fieldIndex = 0; fieldIndex < selectedFields.size(); fieldIndex++) {
            fields += selectedFields[fieldIndex]+',';
        }
        fields = fields.removeEnd(',');
        String query = 'SELECT '+fields+' FROM '+selectedObject+ ' ';
        lstObject = Database.query(query);
        return lstObject;
    }
}