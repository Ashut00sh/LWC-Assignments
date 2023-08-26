public class ObjectData {
	@AuraEnabled
    public static List<String> getAllObjectsNames(){
        // List<Sobject> allObjNamesSet = new List<Sobject>();
        // allObjNamesSet = [SELECT  QualifiedApiName FROM EntityDefinition order by QualifiedApiName];
        // allObjNamesSet.sort();
        // return allObjNamesSet;
        List<Schema.SObjectType> objList = Schema.getGlobalDescribe().Values();     
        List<String> objNames = new List<String>();
        // objNames.add(new SelectOption('','-- Select --'));
        for(Schema.SObjectType obj : objList)
        {
            objNames.add(obj.getDescribe().getName());
        }
        System.debug('objNames1: '+objNames);
        objNames.sort();
        System.debug('objNames2: '+objNames);
        return objNames;
    }

    @AuraEnabled
    public static Map<String,String> getAllObjects(){
        try {
            List<String> lstString = new List<String>();
            map<String, String> allObjectsNameMap = new map<String, String>();
            for(Schema.SobjectType objType: Schema.getGlobalDescribe().values()){
                string name = objType.getDescribe().getLocalName();
                string label = objType.getDescribe().getLabel();
                allObjectsNameMap.put(name, label);
                lstString.add(name);
            }
            //System.debug('before sort lstString: '+lstString);
            //lstString.sort();
            //System.debug('after sort lstString: '+lstString);
            //system.debug('return map: '+ allObjectsNameMap);
            if(!allObjectsNameMap.isEmpty())
            return allObjectsNameMap;
            return allObjectsNameMap;
            //return lstString;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static map<String,String> getAllFieldsOfObject(String strObjectName){
        System.debug('object name: '+ strObjectName);
        map<String, SobjectType> detail = Schema.getGlobalDescribe();
        map<String, String> allfieldsOfSobjMap = new map<String, String>();
        for(Schema.SobjectField fields: detail.get(strObjectName).getDescribe().fields.getMap().values()){
            string name = fields.getDescribe().getName();
            string label = fields.getDescribe().getName();
            allfieldsOfSobjMap.put(name, label);
        }
        System.debug('allfieldsOfSobjMap: '+allfieldsOfSobjMap);
        return allfieldsOfSobjMap;
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
    public static list<Sobject> getRecordsOfSelectedFields(String fieldsName, String objName){
        System.debug('fieldName: '+ fieldsName.replaceAll('[\\[\\](){} ""]', ''));
        System.debug('objName: '+objName);
        String formatedFieldsName =  fieldsName.replaceAll('[\\[\\](){} ""]', '');
        List<Sobject> recordsOfSobject = new List<Sobject>();
        if(formatedFieldsName != null && objName != null){
            String query = 'select '+formatedFieldsName+' from '+objName+' limit 500000' ;
            System.debug('query:: '+ query);
            recordsOfSobject = database.query(query);
        }
        System.debug('return records: '+recordsOfSobject);
        return recordsOfSobject;
    }

    
    @AuraEnabled
    public static List<sObject> getRecordsData(String selectedObject,List<String> selectedFields){
        System.debug('selectedFields:: '+selectedFields);
        List<sObject> lstObject = new List<sObject>();
        String fields = '';
        for (Integer fieldIndex = 0; fieldIndex < selectedFields.size(); fieldIndex++) {
            fields += selectedFields[fieldIndex]+',';
        }
        fields = fields.removeEnd(',');
        System.debug('fields:: '+fields);
        String query = 'SELECT '+fields+' FROM '+selectedObject+ ' ';
        System.debug('query:: '+query);
        lstObject = Database.query(query);
        System.debug('lstObj:: '+lstObject);
        return lstObject;
    }
}