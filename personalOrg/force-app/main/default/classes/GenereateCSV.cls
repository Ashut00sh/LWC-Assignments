public with sharing class GenereateCSV {
    public void createCSVAndSendEmail(string accountId) {
        String csvString = 'OpportunityId, OpportunityName, OpportunityStage\n';
        List<opportunity> opportunityLst = new List<Opportunity>();
        opportunityLst = [SELECT Id, Name, StageName, Account.owner.Email, AccountId FROM Opportunity WHERE AccountId =: accountId];
        for(Opportunity oppObj : opportunityLst){
            csvString += oppObj.Id + ', '+ oppObj.Name+', '+oppObj.StageName+' '; 
        }
        //email attachment 
        Messaging.EmailFileAttachment csvFile = new Messaging.EmailFileAttachment();
        csvFile.setFileName('opportunityData.csv');
        csvFile.setBody(blob.valueof(csvString));
        // send email
        Messaging.SingleEmailMessage emailData = new Messaging.SingleEmailMessage();
        emailData.setToaddresses(new List<String>{opportunityLst[0].Account.owner.Email});
        emailData.setSubject('Opportunity Data');
        emailData.setFileAttachments(new List<Messaging.EmailFileAttachment>{csvFile});
        emailData.setPlainTextBody('Plese find the attachmented required opportunity details.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailData});
    }
}