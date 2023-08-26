public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Opportunity>> getOpportunitiesByWeek() {
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
        return opportunitiesByWeek;
        // for (String weekKey : opportunitiesByWeek.keySet()) {
        //     WeekData weekData = new WeekData();
        //     weekData.week = 'Week ' + weekKey;
        //     weekData.opportunities = opportunitiesByWeek.get(weekKey);
        //     weekDataList.add(weekData);
        // }
        // System.debug('weekDataList: '+weekDataList);
        // return weekDataList;
    }

    public class WeekData {
        @AuraEnabled public String week { get; set; }
        @AuraEnabled public List<Opportunity> opportunities { get; set; }
    }

    public class OpportunityWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public Decimal Amount { get; set; }
        @AuraEnabled public Date CreatedDate { get; set; }
    }
}

// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static List<Opportunity> getOpportunitiesLastSixMonths() {
//         Date sixMonthsAgo = Date.today().addMonths(-6);

//         return [SELECT Id, Name, Amount, CloseDate
//                 FROM Opportunity
//                 WHERE CloseDate >= :sixMonthsAgo
//                 ORDER BY CloseDate DESC];
//     }
// }

// public with sharing class OpportunityController {
// @AuraEnabled(cacheable=true)
// public static List<OpportunityByWeekWrapper> getOpportunitiesByWeek() {
//     List<OpportunityByWeekWrapper> result = new List<OpportunityByWeekWrapper>();

//     Date sixMonthsAgo = Date.today().addMonths(-6);
//     System.debug('sixmonthago: '+sixMonthsAgo);
//     List<AggregateResult> aggResults = [
//         // SELECT WEEK_IN_YEAR(CreatedDate) weekNumber, COUNT(Id) opportunityCount
//         // FROM Opportunity
//         // WHERE CreatedDate >= :sixMonthsAgo
//         // GROUP BY WEEK_IN_YEAR(CreatedDate)
//         SELECT WEEK_IN_YEAR(CreatedDate) weekNumber, COUNT(Id) opportunityCount, Id
//         FROM Opportunity where CreatedDate >= LAST_N_MONTHS:6
//         GROUP BY WEEK_IN_YEAR(CreatedDate)
//     ];
//     System.debug('aggreagateResult: '+aggResults);
//     for (AggregateResult aggResult : aggResults) {
//         Integer weekNumber = (Integer)aggResult.get('weekNumber');
//         Integer opportunityCount = (Integer)aggResult.get('opportunityCount');
//         result.add(new OpportunityByWeekWrapper('Week '+weekNumber, opportunityCount));
//     }
//     System.debug('result::'+result);
//     return result;
// }

//     public class OpportunityByWeekWrapper {
//         @AuraEnabled public String week;
//         @AuraEnabled public Integer opportunityCount;

//         public OpportunityByWeekWrapper(String week, Integer opportunityCount) {
//             this.week = week;
//             this.opportunityCount = opportunityCount;
//         }
//     }
// }


// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static List<WeekData> getOpportunitiesByWeek() {
//         List<WeekData> weekDataList = new List<WeekData>();

//         Date startDate = Date.today().addMonths(-6);
//         Date endDate = Date.today();
//         //
//         Map<String, List<Opportunity>> opportunitiesByWeek = new Map<String, List<Opportunity>>();
//         List<Opportunity> lstOpp = [SELECT Id, Name, Amount, CreatedDate FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate];
//         for (Opportunity opp : lstOpp) {
//             Integer weekNumber = opp.CreatedDate.toStartOfWeek().daysBetween(startDate) / 7;
//             String weekKey = String.valueOf(weekNumber);

//             if (!opportunitiesByWeek.containsKey(weekKey)) {
//                 opportunitiesByWeek.put(weekKey, new List<Opportunity>());
//             }

//             opportunitiesByWeek.get(weekKey).add(opp);
//         }

//         for (String weekKey : opportunitiesByWeek.keySet()) {
//             WeekData weekData = new WeekData();
//             weekData.week = Integer.valueOf(weekKey);
//             weekData.opportunities = opportunitiesByWeek.get(weekKey);
//             weekDataList.add(weekData);
//         }

//         return weekDataList;
//     }

//     public class WeekData {
//         @AuraEnabled public Integer week { get; set; }
//         @AuraEnabled public List<Opportunity> opportunities { get; set; }
//     }

//     public class Opportunity {
//         @AuraEnabled public Id Id { get; set; }
//         @AuraEnabled public String Name { get; set; }
//         @AuraEnabled public Decimal Amount { get; set; }
//     }
// }



// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static List<OpportunityByWeek> getOpportunityByWeekList() {
//         Date today = Date.today();
//         Date sixMonthsAgo = today.addMonths(-6);
    
//         List<Opportunity> opportunities = [SELECT Id, Name, CreatedDate, Amount
//                                           FROM Opportunity
//                                           WHERE CreatedDate >= :sixMonthsAgo AND CreatedDate <= :today
//                                           ORDER BY CreatedDate];
    
//         Map<String, List<Opportunity>> weekToOpportunities = new Map<String, List<Opportunity>>();
    
//         for (Opportunity opp : opportunities) {
//             String weekStartDate = String.valueOf(opp.CreatedDate.toStartOfWeek());
//             if (!weekToOpportunities.containsKey(weekStartDate)) {
//                 weekToOpportunities.put(weekStartDate, new List<Opportunity>());
//             }
//             weekToOpportunities.get(weekStartDate).add(opp);
//         }
    
//         List<OpportunityByWeek> result = new List<OpportunityByWeek>();
//         for (String week : weekToOpportunities.keySet()) {
//             result.add(new OpportunityByWeek(week, weekToOpportunities.get(week)));
//         }
    
//         return result;
//     }

//     public class OpportunityByWeek {
//         @AuraEnabled
//         public String weekStartDate { get; set; }
    
//         @AuraEnabled
//         public List<Opportunity> opportunities { get; set; }
    
//         public OpportunityByWeek(String start, List<Opportunity> opps) {
//             weekStartDate = start;
//             opportunities = opps;
//         }
//     }
// }

// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static Map<String, List<Opportunity>> getOpportunityMap() {
//         Date today = Date.today();
//         Date sixMonthsAgo = today.addMonths(-6);
//         System.debug('sixMonthsAgo: '+sixMonthsAgo);
//         List<Opportunity> opportunities = [SELECT Id, Name, CreatedDate, Amount
//                                           FROM Opportunity
//                                           WHERE CreatedDate >= :sixMonthsAgo AND CreatedDate <= :today
//                                           ORDER BY CreatedDate];
    
//         Map<String, List<Opportunity>> opportunityMap = new Map<String, List<Opportunity>>();
    
//         for (Opportunity opp : opportunities) {
//             String weekStartDate = String.valueOf(opp.CreatedDate);
//             if (!opportunityMap.containsKey(weekStartDate)) {
//                 opportunityMap.put(weekStartDate, new List<Opportunity>());
//             }
//             opportunityMap.get(weekStartDate).add(opp);
//         }
    
//         return opportunityMap;
//     }
// }





// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static List<Opportunity> getOpportunitiesByWeek() {
//         Date today = Date.today();
//         Date sixMonthsAgo = today.addMonths(-6);
    
//         List<Opportunity> opportunities = [SELECT Id, Name, CreatedDate, Amount
//                                           FROM Opportunity
//                                           WHERE CreatedDate >= :sixMonthsAgo AND CreatedDate <= :today
//                                           ORDER BY CreatedDate];
    
//         return opportunities;
//     }
// }










// public with sharing class OpportunityController {
//     @AuraEnabled(cacheable=true)
//     public static List<Opportunity> getOpportunityList() {
//         Date today = Date.today();
//         Date sixMonthsAgo = today.addMonths(-6);
    
//         List<Opportunity> opportunities = [SELECT Id, Name, CloseDate, Amount
//                                           FROM Opportunity
//                                           WHERE CloseDate >= :sixMonthsAgo AND CloseDate <= :today
//                                           ORDER BY CloseDate];
    
//         return opportunities;
//     }
// }