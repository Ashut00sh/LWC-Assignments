public class AssignAccount {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContact(String accountId){
        List<Contact> contactLst = [SELECT Id, Name, Email,AccountId FROM Contact WHERE AccountId =: accountId];
        return contactLst;
    }
    @AuraEnabled
    public static boolean assignAccount(String accountId, String contactId){
        system.debug('in account: '+accountId);
        system.debug('in contact: '+contactId);
        List<Contact> contactLstToUpdate = new List<Contact>();
        List<contact> contactLst = [select id, Name, Email, AccountId From Contact Where Id =: contactId and AccountId =: accountId];
        for(contact contactObj : contactLst){
            contact obj = new contact();
            obj.AccountId = accountId;
            contactLstToUpdate.add(obj);
        }
        system.debug('contactLstToUpdate: '+contactLstToUpdate);
        if(contactLstToUpdate != null && !contactLstToUpdate.isEmpty()){
            system.debug('contactLstToUpdate: '+contactLstToUpdate);
            Upsert contactLstToUpdate;
            return true;
        }
        return false;
    }

}