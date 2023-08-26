public with sharing class OpportunityTriggerHandler {
    public void countTotalOpportunities(Set<Id> accountIds){
        List<Account> accountToUpdateLst = new List<Account>();
        Account accountObj;
        for(AggregateResult agr : [SELECT COUNT(Id) totalOppCount, AccountId FROM Opportunity WHERE AccountId IN: accountIds GROUP BY AccountId]){
            accountObj = new Account();
            accountObj.Id = (Id)agr.get('AccountId');
            accountObj.Count__c = (Decimal) agr.get('totalOppCount');
            accountToUpdateLst.add(accountObj);
        }
        if(!accountToUpdateLst.isEmpty()){
            Update accountToUpdateLst;
        }
    }
}