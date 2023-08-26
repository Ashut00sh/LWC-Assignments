public class CraeateRecord {

    @AuraEnabled
    public static list<Account>insertAccountRecords(string accName, string accNum){
        system.debug('name and munber: '+accName+' '+accNum);
        List<Account> accList = new List<Account>();
        if(accName !=null && accNum != null){
            Account accountObj = new Account();
            accountObj.Name = accName;
            accountObj.AccountNumber = accNum;
            accList.add(accountObj);
        }
        if(!accList.isEmpty())
            Insert accList;
        return accList;
    }
    
    @AuraEnabled
    public static list<Account>updatAccRecord(string accountId, string accName, String accNum, String accWebsite){
        list<Account> lstAccToUpdate = new List<Account>();
        System.debug('accId: '+accountId);
        for(Account accountObj : [select Id, Name, Website, AccountNumber from Account where Id =: accountId]){
            accountObj.Name = accName;
            accountObj.AccountNumber = accNum;
            accountObj.Website = accWebsite;
            lstAccToUpdate.add(accountObj);
        }

        if(!lstAccToUpdate.isEmpty()){
            Update lstAccToUpdate;
        }
        return lstAccToUpdate;
    }
}