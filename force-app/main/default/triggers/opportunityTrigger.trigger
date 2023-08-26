trigger opportunityTrigger on Opportunity (before insert, after insert, after update, after delete, after undelete) {
    //Before Insert
    if(trigger.isBefore && trigger.isInsert){
        Set<Id> accountIdsSet = new Set<Id>();
        System.debug('before insert: '+trigger.new);
        for(Opportunity oppObj :trigger.new){
           if(oppObj.AccountId != null){
                accountIdsSet.add(oppObj.AccountId);    
           }
        }
        map<Id, Account> mapIdVsAccountObj = new map<Id, Account>([SELECT Id, ownerId FROM Account WHERE Id IN: accountIdsSet]);
       for(Opportunity oppObj : trigger.new){
            if(oppObj.AccountId != NULL && oppObj.Account.ownerId != NULL)
            oppObj.ownerId = mapIdVsAccountObj.get(oppObj.AccountId).ownerId;
        }
    }
    //after insert
    if(trigger.isInsert && trigger.isAfter){
        System.debug('after insert context: ');
        Set<Id> accountIdsSet = new Set<Id>();
        for(Opportunity oppObj : trigger.new){
            if(oppObj.AccountId != null){
                accountIdsSet.add(oppObj.AccountId);
            }
        }
        if(!accountIdsSet.isEmpty()){
            OpportunityTriggerHandler oppTriggerHanlderObj = new OpportunityTriggerHandler();
            oppTriggerHanlderObj.countTotalOpportunities(accountIdsSet);
        }
    }
    //after update 
    if(trigger.isUpdate && trigger.isAfter){
        System.debug('after update context: ');
        Set<Id> accountIdsSet = new Set<Id>();
        for(Opportunity oppObj : trigger.new){
            if(oppObj.AccountId != null && oppObj.AccountId != trigger.oldMap.get(oppObj.Id).AccountId){
                accountIdsSet.add(oppObj.AccountId);
                accountIdsSet.add(trigger.oldMap.get(oppObj.Id).AccountId);
            }
        }
        if(!accountIdsSet.isEmpty()){
            OpportunityTriggerHandler oppTriggerHanlderObj = new OpportunityTriggerHandler();
            oppTriggerHanlderObj.countTotalOpportunities(accountIdsSet);
        }
    }
    //after delete
    if(trigger.isDelete && trigger.isAfter){
        System.debug('after delete context: ');
        Set<Id> accountIdsSet = new Set<Id>();
        for(Opportunity oppObj : trigger.old){
            if(oppObj.AccountId != null){
                accountIdsSet.add(oppObj.AccountId);
            }
        }
        if(!accountIdsSet.isEmpty()){
            OpportunityTriggerHandler oppTriggerHanlderObj = new OpportunityTriggerHandler();
            oppTriggerHanlderObj.countTotalOpportunities(accountIdsSet);
        }
    }
    //after undelte
    if(trigger.isAfter){
        System.debug('after undelete context: ');
        if(trigger.isUnDelete){
            Set<Id> accountIdsSet = new Set<Id>();
            for(Opportunity oppObj : trigger.new){
                if(oppObj.AccountId != null){
                    accountIdsSet.add(oppObj.AccountId);
                }
            }
            if(!accountIdsSet.isEmpty()){
                OpportunityTriggerHandler oppTriggerHanlderObj = new OpportunityTriggerHandler();
                oppTriggerHanlderObj.countTotalOpportunities(accountIdsSet);
            }
        }
    }
}