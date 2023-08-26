public class RS_LocationOverviewController {

    public Date startDate {get;set;}

    public Date endDate {get;set;}

 

    public List<RS_ScoreDetails> reviewMetrics {get; set;}

    public List<RS_ScoreDetails> overallScoreAverages {get; set;}

    public Boolean viewAll {get; set;}

    private List<Dashboard> rsDashboards;

    private List<Report> rsReports;

    private List<Decimal> locationList;

 

    public List<RS_LocationScores> locations {get; set;}

    private Map<String, AggregateResult[]> locationScoreMap;

 

    public String sortBy {get; set;}

    public boolean isAsc {get; set;}

    private String lastSortedColumn;    

 

    public RS_LocationOverviewController(){

        // TODO: Pass selected date range

        setDateRange();

        setupLocations();

        setLocationScores();

        setupReviewMetrics();

        setupOverallAvgs();

    }

 

    private void setDateRange(){

        Date tempDate = CHW_Utility.getLastWeekdayDate('Wednesday');

        if(CHW_Utility.getWeekday(System.today()).equals('Wednesday')){

            tempDate = tempDate.addDays(-7);

        }

 

        this.endDate = tempDate;

 

        tempDate = tempDate.addDays(-6);

        this.startDate = tempDate;

        System.debug('Startdatse'+this.startDate);

        System.debug('endDate'+this.endDate);

 

    }

 

    private List<revue__Place__c> setLocationList(){

        String email = UserInfo.getUserEmail().replaceAll('[@.-]', '_');

        locationList = new List<Decimal>();

        List<revue__Place__c> locationResults;

        try{

            List<String> tempList = [

            SELECT Location_List__c

            FROM Location_Mapping__mdt

            WHERE DeveloperName =: email

            LIMIT 1

            ].Location_List__c.split(',');

            for(String place : tempList){

                locationList.add(Decimal.valueOf(place));

            }

 

            locationResults = [

            SELECT id, name, revue__Store_Number__c

            FROM revue__Place__c

            WHERE

                id != 'a281K000002Zt2zQAC' AND

                revue__Store_Number__c in :locationList

            ORDER BY name asc

            ];

 

            this.viewAll = false;

            System.debug('In fi location Results'+locationList);

            return locationResults ;

        }

        catch(Exception e){

            locationResults = [

            SELECT id, name, revue__Store_Number__c

            FROM revue__Place__c

            WHERE id != 'a281K000002Zt2zQAC'

            ORDER BY name asc

            ];

 

            for(revue__Place__c place : locationResults){

                locationList.add(place.revue__Store_Number__c);

            }

 

            this.viewAll = true;

            System.debug('In else location Results'+locationList);

            return locationResults;

        }

    }

 

    private void setupLocations(){

        this.sortBy = 'Location';

        this.lastSortedColumn = this.sortBy;

        this.isAsc = true;

        this.locations = new List<RS_LocationScores>();

       

        List<revue__Place__c> locationResults = setLocationList();

 

        rsDashboards = queryDashboards();

        System.debug('rsDashboards'+rsDashboards);

        System.debug('locationResults'+locationResults);

 

        for(revue__Place__c l : locationResults){

            // Assumes the names are standardized:

     

            Map<String, Dashboard> dashboardList = new Map<String, Dashboard>();

            String category = '';

            for(Dashboard d : rsDashboards){

                System.debug('DDDDDDDDD'+d);

                System.debug('l is'+l);

                String locationName = l.name.substring(0,l.name.length() - 4); // Trim the state off the end of the name

                System.debug('lOcatoin name'+locationName);

                if(d.title.containsIgnoreCase(locationName)){

                    category = d.title.replaceAll(locationName+'|[\\s-]|[Ss]ummary', '');

                    dashboardList.put(category,d);

                }

            }

            this.locations.add(new RS_LocationScores(l, dashboardList));

            System.debug('Location are'+this.locations);

        }

    }

 

    private List<Dashboard> queryDashboards(){

        List<Dashboard> dashboardResults = [

            SELECT id, title

            FROM Dashboard

            WHERE

                FolderName like 'RS %' AND

                (NOT title like '%M2D%')

            ORDER BY FolderName asc

        ];

 

        return dashboardResults;

    }

 

    private void setLocationScores(){

        locationScoreMap = new Map<String,AggregateResult[]>();

        List<revue__Review__c> aa = [SELECT Id,Name,revue__Review_Date__c,revue__Review_Length__c,revue__Place__r.revue__Store_Number__c FROM revue__Review__c];

        System.debug('a78787a'+aa);

        System.debug('a78787a'+locationList);

 

        locationScoreMap.put('OverallScore', [

            SELECT revue__Place__r.name name, AVG(revue__Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('FoodScore', [

            SELECT revue__Place__r.name name, AVG(Food_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('MenuScore', [

            SELECT revue__Place__r.name name, AVG(Menu_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('BeverageScore', [

            SELECT revue__Place__r.name name, AVG(Beverages_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('ServiceScore', [

            SELECT revue__Place__r.name name, AVG(Service_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('F&AScore', [

            SELECT revue__Place__r.name name, AVG(Facilities_and_Amenities_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        System.debug('Locations core put'+locationScoreMap);

 

        for(RS_LocationScores l : locations){

            for(AggregateResult ag : locationScoreMap.get('OverallScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgOverallScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgOverallScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('FoodScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgFoodScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgFoodScore.setScore(0.0);}

                    break;

                }

            }

           

            for(AggregateResult ag : locationScoreMap.get('BeverageScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgBeverageScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgBeverageScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('ServiceScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgServiceScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgServiceScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('MenuScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgMenuScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgMenuScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('F&AScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgFAScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgFAScore.setScore(0.0);}

                    break;

                }

            }

        }

    }

 

    private void setupReviewMetrics(){

        reviewMetrics = new List<RS_ScoreDetails>();

        Map<String, AggregateResult[]> metricMap = new Map<String, AggregateResult[]>();

       

        rsReports = [

            SELECT id, name

            FROM Report

            WHERE

                foldername like 'Operations %' AND

                name like 'Cooper\'s Hawk%' AND

                name like '%7%'

        ];

 

        reviewMetrics.add(new RS_ScoreDetails(getAverage('OverallScore'),getReport('Sentiment')));

       

        metricMap.put('Content', [

            SELECT Count(Id) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        metricMap.put('Total Records', [

            SELECT Count(Id) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        metricMap.put('Star Rating', [

            SELECT AVG(Rating__c ) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c > 0 AND

                revue__Origin__c in ('TripAdvisor','OpenTable','Google','Yelp') AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        for(String key : metricMap.keySet()){

            AggregateResult ag = metricMap.get(key)[0];

            RS_ScoreDetails temp;

            if(key.equals('Star Rating')){

                if(ag.get('score') != null) {

                    temp = new RS_ScoreDetails(((Decimal)ag.get('score')).setScale(1),getReport(key));

                } else {temp = new RS_ScoreDetails(0.0,getReport(key));}

 

            }

            else{

                if(ag.get('score') != null) {

                    temp = new RS_ScoreDetails(((Decimal)ag.get('score')).setScale(0),getReport(key));

                } else {temp = new RS_ScoreDetails(0.0,getReport(key));}

            }

           

            if(!this.viewAll){

                temp.hideLink();

            }

            reviewMetrics.add(temp);

        }

    }

 

    private void setupOverallAvgs(){

        overallScoreAverages = new List<RS_ScoreDetails>();

        System.debug('locationScoreMap'+locationScoreMap);
        for(String key : locationScoreMap.keySet()){

            SYstem.debug('key'+key);

            System.debug('getavg'+getAverage(key));

            System.debug('getdash'+getDashboard(key));

            if(!key.equals('OverallScore')){

                overallScoreAverages.add(new RS_ScoreDetails(getAverage(key),getDashboard(key)));

            }

        }

    }

 

    private Decimal getAverage(String key){

        decimal sum = 0.0;

        Integer nonZeroRecordCount = 0;

        for(AggregateResult ag : locationScoreMap.get(key)){

            if(ag.get('score') != null && ag.get('score') != 0) {

                sum += ((Decimal)ag.get('score'));

                nonZeroRecordCount++;

        }

        }

       

        decimal averageScore = 0.0;

        if(nonZeroRecordCount > 0){

            averageScore = (sum/nonZeroRecordCount);

        }

        return averageScore.setScale(1);

    }

 

    private Dashboard getDashboard(String key){

        String searchValue = key.substring(0, key.length()-5); //Remove 'Score'

        System.debug('asas'+searchValue);

        System.debug('rsDashboards'+rsDashboards);

 

        if(searchValue.equals('Overall')){

            searchValue = 'Sentiment';

        }

        Dashboard returnBoard;

        for(Dashboard d : rsDashboards){

            String title = d.title.remove(' ');

            if(title.contains(searchValue) && title.contains('Cooper\'sHawk')){

                returnBoard = d;

                break;

            }

        }

        return returnBoard;

    }

 

    private Report getReport(String key){

        Report report;

        for(Report r : rsReports){

            if(r.name.contains(key) && r.name.contains('Cooper\'s Hawk')){

                report = r;

                break;

            }

        }

        return report;

    }

 

    // Sorting Methods

    public void sortByLocation(){

        this.sortBy = 'Location';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByOverall(){

        this.sortBy = 'Overall';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByFood(){

        this.sortBy = 'Food';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByMenu(){

        this.sortBy = 'Menu';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByBeverage(){

        this.sortBy = 'Beverage';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByService(){

        this.sortBy = 'Service';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByFA(){

        this.sortBy = 'FA';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    // public void sortByOther(){

    //     this.sortBy = 'Other';

    //     flipSortOrder();

    //     updateLocationSortOrder();

    //     this.locations.sort();

    // }

 

    public void flipSortOrder(){

        if(this.lastSortedColumn.equals(this.sortBy)){

            this.isAsc = !this.isAsc;

        }

        else{

            this.lastSortedColumn = this.sortBy;

            this.isAsc = true;

        }

    }

 

    public void updateLocationSortOrder(){

        RS_LocationScores.lSortBy = this.sortBy;

        if(this.isAsc){ RS_LocationScores.lSortValue = 1;}

        else{RS_LocationScores.lSortValue = -1;}

    }

}public class RS_LocationOverviewController {

    public Date startDate {get;set;}

    public Date endDate {get;set;}

 

    public List<RS_ScoreDetails> reviewMetrics {get; set;}

    public List<RS_ScoreDetails> overallScoreAverages {get; set;}

    public Boolean viewAll {get; set;}

    private List<Dashboard> rsDashboards;

    private List<Report> rsReports;

    private List<Decimal> locationList;

 

    public List<RS_LocationScores> locations {get; set;}

    private Map<String, AggregateResult[]> locationScoreMap;

 

    public String sortBy {get; set;}

    public boolean isAsc {get; set;}

    private String lastSortedColumn;    

 

    public RS_LocationOverviewController(){

        // TODO: Pass selected date range

        setDateRange();

        setupLocations();

        setLocationScores();

        setupReviewMetrics();

        setupOverallAvgs();

    }

 

    private void setDateRange(){

        Date tempDate = CHW_Utility.getLastWeekdayDate('Wednesday');

        if(CHW_Utility.getWeekday(System.today()).equals('Wednesday')){

            tempDate = tempDate.addDays(-7);

        }

 

        this.endDate = tempDate;

 

        tempDate = tempDate.addDays(-6);

        this.startDate = tempDate;

        System.debug('Startdatse'+this.startDate);

        System.debug('endDate'+this.endDate);

 

    }

 

    private List<revue__Place__c> setLocationList(){

        String email = UserInfo.getUserEmail().replaceAll('[@.-]', '_');

        locationList = new List<Decimal>();

        List<revue__Place__c> locationResults;

        try{

            List<String> tempList = [

            SELECT Location_List__c

            FROM Location_Mapping__mdt

            WHERE DeveloperName =: email

            LIMIT 1

            ].Location_List__c.split(',');

            for(String place : tempList){

                locationList.add(Decimal.valueOf(place));

            }

 

            locationResults = [

            SELECT id, name, revue__Store_Number__c

            FROM revue__Place__c

            WHERE

                id != 'a281K000002Zt2zQAC' AND

                revue__Store_Number__c in :locationList

            ORDER BY name asc

            ];

 

            this.viewAll = false;

            System.debug('In fi location Results'+locationList);

            return locationResults ;

        }

        catch(Exception e){

            locationResults = [

            SELECT id, name, revue__Store_Number__c

            FROM revue__Place__c

            WHERE id != 'a281K000002Zt2zQAC'

            ORDER BY name asc

            ];

 

            for(revue__Place__c place : locationResults){

                locationList.add(place.revue__Store_Number__c);

            }

 

            this.viewAll = true;

            System.debug('In else location Results'+locationList);

            return locationResults;

        }

    }

 

    private void setupLocations(){

        this.sortBy = 'Location';

        this.lastSortedColumn = this.sortBy;

        this.isAsc = true;

        this.locations = new List<RS_LocationScores>();

       

        List<revue__Place__c> locationResults = setLocationList();

 

        rsDashboards = queryDashboards();

        System.debug('rsDashboards'+rsDashboards);

        System.debug('locationResults'+locationResults);

 

        for(revue__Place__c l : locationResults){

            // Assumes the names are standardized:

     

            Map<String, Dashboard> dashboardList = new Map<String, Dashboard>();

            String category = '';

            for(Dashboard d : rsDashboards){

                System.debug('DDDDDDDDD'+d);

                System.debug('l is'+l);

                String locationName = l.name.substring(0,l.name.length() - 4); // Trim the state off the end of the name

                System.debug('lOcatoin name'+locationName);

                if(d.title.containsIgnoreCase(locationName)){

                    category = d.title.replaceAll(locationName+'|[\\s-]|[Ss]ummary', '');

                    dashboardList.put(category,d);

                }

            }

            this.locations.add(new RS_LocationScores(l, dashboardList));

            System.debug('Location are'+this.locations);

        }

    }

 

    private List<Dashboard> queryDashboards(){

        List<Dashboard> dashboardResults = [

            SELECT id, title

            FROM Dashboard

            WHERE

                FolderName like 'RS %' AND

                (NOT title like '%M2D%')

            ORDER BY FolderName asc

        ];

 

        return dashboardResults;

    }

 

    private void setLocationScores(){

        locationScoreMap = new Map<String,AggregateResult[]>();

        List<revue__Review__c> aa = [SELECT Id,Name,revue__Review_Date__c,revue__Review_Length__c,revue__Place__r.revue__Store_Number__c FROM revue__Review__c];

        System.debug('a78787a'+aa);

        System.debug('a78787a'+locationList);

 

        locationScoreMap.put('OverallScore', [

            SELECT revue__Place__r.name name, AVG(revue__Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('FoodScore', [

            SELECT revue__Place__r.name name, AVG(Food_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('MenuScore', [

            SELECT revue__Place__r.name name, AVG(Menu_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('BeverageScore', [

            SELECT revue__Place__r.name name, AVG(Beverages_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('ServiceScore', [

            SELECT revue__Place__r.name name, AVG(Service_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        locationScoreMap.put('F&AScore', [

            SELECT revue__Place__r.name name, AVG(Facilities_and_Amenities_Sentiment__c) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c  > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

            GROUP BY revue__Place__r.name

        ]);

 

        System.debug('Locations core put'+locationScoreMap);

 

        for(RS_LocationScores l : locations){

            for(AggregateResult ag : locationScoreMap.get('OverallScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgOverallScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgOverallScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('FoodScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgFoodScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgFoodScore.setScore(0.0);}

                    break;

                }

            }

           

            for(AggregateResult ag : locationScoreMap.get('BeverageScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgBeverageScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgBeverageScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('ServiceScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgServiceScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgServiceScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('MenuScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgMenuScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgMenuScore.setScore(0.0);}

                    break;

                }

            }

 

            for(AggregateResult ag : locationScoreMap.get('F&AScore')){

                if(ag.get('name').equals(l.location.name)){

                    if(ag.get('score') != null){l.avgFAScore.setScore(((Decimal) ag.get('score')).setScale(1));}

                    else{l.avgFAScore.setScore(0.0);}

                    break;

                }

            }

        }

    }

 

    private void setupReviewMetrics(){

        reviewMetrics = new List<RS_ScoreDetails>();

        Map<String, AggregateResult[]> metricMap = new Map<String, AggregateResult[]>();

       

        rsReports = [

            SELECT id, name

            FROM Report

            WHERE

                foldername like 'Operations %' AND

                name like 'Cooper\'s Hawk%' AND

                name like '%7%'

        ];

 

        reviewMetrics.add(new RS_ScoreDetails(getAverage('OverallScore'),getReport('Sentiment')));

       

        metricMap.put('Content', [

            SELECT Count(Id) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c > 0 AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        metricMap.put('Total Records', [

            SELECT Count(Id) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        metricMap.put('Star Rating', [

            SELECT AVG(Rating__c ) score

            FROM revue__Review__c

            WHERE

                revue__Review_Date__c >= :this.startDate AND

                revue__Review_Date__c <= :this.endDate AND

                revue__Review_Length__c > 0 AND

                revue__Origin__c in ('TripAdvisor','OpenTable','Google','Yelp') AND

                revue__Place__r.revue__Store_Number__c in :locationList

        ]);

 

        for(String key : metricMap.keySet()){

            AggregateResult ag = metricMap.get(key)[0];

            RS_ScoreDetails temp;

            if(key.equals('Star Rating')){

                if(ag.get('score') != null) {

                    temp = new RS_ScoreDetails(((Decimal)ag.get('score')).setScale(1),getReport(key));

                } else {temp = new RS_ScoreDetails(0.0,getReport(key));}

 

            }

            else{

                if(ag.get('score') != null) {

                    temp = new RS_ScoreDetails(((Decimal)ag.get('score')).setScale(0),getReport(key));

                } else {temp = new RS_ScoreDetails(0.0,getReport(key));}

            }

           

            if(!this.viewAll){

                temp.hideLink();

            }

            reviewMetrics.add(temp);

        }

    }

 

    private void setupOverallAvgs(){

        overallScoreAverages = new List<RS_ScoreDetails>();

        System.debug('locationScoreMap'+locationScoreMap);

       

 

        for(String key : locationScoreMap.keySet()){

            SYstem.debug('key'+key);

            System.debug('getavg'+getAverage(key));

            System.debug('getdash'+getDashboard(key));

            if(!key.equals('OverallScore')){

                overallScoreAverages.add(new RS_ScoreDetails(getAverage(key),getDashboard(key)));

            }

        }

    }

 

    private Decimal getAverage(String key){

        decimal sum = 0.0;

        Integer nonZeroRecordCount = 0;

        for(AggregateResult ag : locationScoreMap.get(key)){

            if(ag.get('score') != null && ag.get('score') != 0) {

                sum += ((Decimal)ag.get('score'));

                nonZeroRecordCount++;

        }

        }

       

        decimal averageScore = 0.0;

        if(nonZeroRecordCount > 0){

            averageScore = (sum/nonZeroRecordCount);

        }

        return averageScore.setScale(1);

    }

 

    private Dashboard getDashboard(String key){

        String searchValue = key.substring(0, key.length()-5); //Remove 'Score'

        System.debug('asas'+searchValue);

        System.debug('rsDashboards'+rsDashboards);

 

        if(searchValue.equals('Overall')){

            searchValue = 'Sentiment';

        }

        Dashboard returnBoard;

        for(Dashboard d : rsDashboards){

            String title = d.title.remove(' ');

            if(title.contains(searchValue) && title.contains('Cooper\'sHawk')){

                returnBoard = d;

                break;

            }

        }

        return returnBoard;

    }

 

    private Report getReport(String key){

        Report report;

        for(Report r : rsReports){

            if(r.name.contains(key) && r.name.contains('Cooper\'s Hawk')){

                report = r;

                break;

            }

        }

        return report;

    }

 

    // Sorting Methods

    public void sortByLocation(){

        this.sortBy = 'Location';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByOverall(){

        this.sortBy = 'Overall';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByFood(){

        this.sortBy = 'Food';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByMenu(){

        this.sortBy = 'Menu';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByBeverage(){

        this.sortBy = 'Beverage';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByService(){

        this.sortBy = 'Service';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    public void sortByFA(){

        this.sortBy = 'FA';

        flipSortOrder();

        updateLocationSortOrder();

        this.locations.sort();

    }

 

    // public void sortByOther(){

    //     this.sortBy = 'Other';

    //     flipSortOrder();

    //     updateLocationSortOrder();

    //     this.locations.sort();

    // }

 

    public void flipSortOrder(){

        if(this.lastSortedColumn.equals(this.sortBy)){

            this.isAsc = !this.isAsc;

        }

        else{

            this.lastSortedColumn = this.sortBy;

            this.isAsc = true;

        }

    }

 

    public void updateLocationSortOrder(){

        RS_LocationScores.lSortBy = this.sortBy;

        if(this.isAsc){ RS_LocationScores.lSortValue = 1;}

        else{RS_LocationScores.lSortValue = -1;}

    }

}