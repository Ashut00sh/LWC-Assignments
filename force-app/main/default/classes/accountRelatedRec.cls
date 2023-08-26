public with sharing class accountRelatedRec {
    @AuraEnabled
    public static List<Account> getRelatedRec(string accId){
        try {
            system.debug('accId: '+accId);
            List<Account> accToReturn = new List<Account>();
            //parent (Account ) to child (Contact and opportunity ) query
            accToReturn = [select id, (select Id,Name,Email from Contacts), (select Id,name from Opportunities) from Account where Id =: accId];
           System.debug('accList: '+accToReturn);
            return accToReturn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
  
}