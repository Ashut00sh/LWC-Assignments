public class ReportGenerator {
    public List<Integer> data { get; set; }
    
    public ReportGenerator(List<Integer> inputData) {
        data = inputData;
    }
    
    public String generateReport() {
        String report = 'Sample Report:\n';
        Integer total = 0;
        
        for (Integer value : data) {
            total += value;
        }
        
        Decimal average = total / Decimal.valueOf(data.size());
        
        report += 'Total: ' + String.valueOf(total) + '\n';
        report += 'Average: ' + String.valueOf(average) + '\n';
        
        return report;
    }
}
