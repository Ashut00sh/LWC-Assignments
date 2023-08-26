trigger AccountTrigger on Account (after update, before delete, after insert) {
    if(trigger.isUpdate && trigger.isAfter){
        //if account owner is changed then change the related opportunity owner 
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> accToOppSet = new Set<Id>();
        for(Account accObj : trigger.new){
            accToOppSet.add(accObj.Id);
            if(accObj.ownerId != trigger.oldMap.get(accObj.Id).ownerId){
                accountIdSet.add(accObj.Id);
            }
        }
        list<Opportunity> opportunityLst = new List<Opportunity>();
        for(opportunity oppObj : [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN: accountIdSet]){
           // opportunity opportunityObj = new opportunity();
           oppObj.OwnerId = trigger.newMap.get(oppObj.AccountId).ownerId;
            opportunityLst.add(oppObj);
        }
        if(!opportunityLst.isEmpty()){
            Update opportunityLst;
        }
        //
        map<Id, Account> mapOfAccIdToAccObj = new map<Id, Account>();
        for(Account accObj : trigger.new){
            System.debug('billing state:: '+accObj.Billing_State__c);
            System.debug('billing state old:: '+trigger.oldmap.get(accObj.Id).Billing_State__c);
            if(accObj.Billing_State__c != trigger.oldmap.get(accObj.Id).Billing_State__c){
                mapOfAccIdToAccObj.put(accObj.Id, accObj);
            }
        }
        list<Contact> contactToUpdateLst = new List<Contact>();
        for(Contact conObj : [SELECT Id, AccountId FROM Contact WHERE AccountId IN : mapOfAccIdToAccObj.keySet()]){
            conObj.Account_Billing_State__c = mapOfAccIdToAccObj.get(conObj.AccountId).Billing_State__c ;
            contactToUpdateLst.add(conObj);
        }
        if(!contactToUpdateLst.isEmpty()){
            System.debug('update contact:: '+ contactToUpdateLst);
            Update contactToUpdateLst;
        }
        //Check related opportunity having closedDate greater than 30 days from today
        //If yes then change the opp status to closed lost 
        List<Opportunity> opportuityLst = new List<Opportunity>();
        for(Opportunity oppObj : [SELECT Id, StageName, CreatedDate FROM Opportunity WHERE AccountId IN: accToOppSet]){
           System.debug('before If: '+ oppObj);
           //System.debug('date: '+System.now()-30);
            if(oppObj.CreatedDate < (System.now()-30) && oppObj.StageName != 'Closed Won'){
                oppObj.StageName = 'Closed Lost';
                oppObj.CloseDate = system.today();
                System.debug('opp:: '+oppObj);
                opportuityLst.add(oppObj);
            }
        }
        if(!opportuityLst.IsEmpty()){
            Update opportuityLst;
        }
    }

    if(trigger.isdelete && trigger.isBefore){
        set<Id> accountIdSet = new set<Id>();
        for(Case caseObj : [SELECT Id, AccountId,Status FROM Case WHERE AccountId IN: trigger.oldMap.keySet() and Status != 'Closed']){
            if(caseObj.Status != 'Closed'){
                accountIdSet.add(caseObj.AccountId);
            }
        }
        for(Account accObj : trigger.old){
            System.debug('account owner: '+accObj.OwnerId);
            System.debug('running user: '+userInfo.getUserId());
            if(accObj.OwnerId != userInfo.getUserId() || accountIdSet.contains(accObj.Id)){
                accObj.addError('You can not delete the account it is having related case which status is not closed or you are not owner of this account');
            }            
        }
    }

    if(trigger.isInsert && trigger.isAfter){
        Integer i = 0;
        System.debug('account after insert:: ');
        try{
            List<Contact> contactLst = new List<Contact>();
            for(Account accountObj : trigger.new){
                System.debug('account trigger new: '+accountObj);
                contact contactObj = new contact();
                contactObj.LastName = accountObj.Name +' '+ i++;
                contactObj.AccountId = accountObj.Id;
                contactLst.add(contactObj);
            }
            System.debug('trigger Executing:: '+trigger.isExecuting);
            if(!contactLst.isEmpty() && StopRecurssionTrigger.runOnce()){
                Insert contactLst;
            }
        }catch(Exception exp){
            System.debug('Exception:: '+ exp.getMessage());
        }
    }
}