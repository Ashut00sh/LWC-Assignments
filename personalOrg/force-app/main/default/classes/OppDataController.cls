public with sharing class OppDataController {
    @AuraEnabled(cacheable=true)
    public static String getOpportunityMap() {
        List<WeekData> weekDataList = new List<WeekData>();

        Date startDate = Date.today().addMonths(-6);
        Date endDate = Date.today();

        Map<String, List<Opportunity>> opportunitiesByWeek = new Map<String, List<Opportunity>>();
        List<Opportunity> lstOpportunity = new List<Opportunity>([SELECT Id, Name, Amount, CreatedDate,CloseDate FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate]);
        System.debug('lstopportunity: '+lstOpportunity);
        for (Opportunity opp : lstOpportunity) {
			DateTime dT = opp.CreatedDate;
			Date createdDate = date.newinstance(dT.year(), dT.month(), dT.day());
            Integer weekNumber = createdDate.toStartOfWeek().daysBetween(startDate) / 7;
            String weekKey = 'Week'+String.valueOf(weekNumber);
            System.debug('weekKey:: '+weekKey);
            if (!opportunitiesByWeek.containsKey(weekKey)) {
                opportunitiesByWeek.put(weekKey, new List<Opportunity>());
            }
            opportunitiesByWeek.get(weekKey).add(opp);
        }
        System.debug('opportunitiesByWeek: '+opportunitiesByWeek);
        //return opportunitiesByWeek;
        for (String weekKey : opportunitiesByWeek.keySet()) {
            WeekData weekData = new WeekData();
            weekData.week = weekKey;
            weekData.opportunities = opportunitiesByWeek.get(weekKey);
            weekData.opportunities.sort();
            weekData.isVisible = false;
            weekDataList.add(weekData);
        }
        System.debug('weekDataList: '+weekDataList);
        System.debug('jsonData:: '+JSON.serializePretty(weekDataList));
        System.debug('jsonDataPretty:: '+JSON.serialize(weekDataList));
        return JSON.serializePretty(weekDataList);
    }

    public class WeekData {
        @AuraEnabled public String week { get; set; }
        @AuraEnabled public List<Opportunity> opportunities { get; set; }
        @AuraEnabled public Boolean isVisible = false;
    }
}
