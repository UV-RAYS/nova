import Foundation
import Combine

/// ViewModel for the report view
class ReportViewModel: ObservableObject {
    @Published var reportCard: ReportCard?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let reportService: ReportService
    private var cancellables = Set<AnyCancellable>()
    
    init(reportService: ReportService) {
        self.reportService = reportService
        
        setupBindings()
    }
    
    /// Set up bindings between report service and published properties
    private func setupBindings() {
        reportService.$reportCard
            .sink { [weak self] report in
                self?.reportCard = report
            }
            .store(in: &cancellables)
    }
    
    /// Generate a new report
    func generateReport() {
        isLoading = true
        errorMessage = nil
        
        Task {
            await reportService.generateNightlyReport()
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    /// Load existing reports
    func loadReports() {
        // In a full implementation, this would load historical reports
    }
    
    /// Export report as JSON
    func exportAsJSON() -> Data? {
        guard let report = reportCard else { return nil }
        
        do {
            let data = try JSONEncoder().encode(report)
            return data
        } catch {
            errorMessage = "Failed to export report: \(error.localizedDescription)"
            return nil
        }
    }
    
    /// Export report as PDF
    func exportAsPDF() -> Data? {
        // In a full implementation, this would generate a PDF
        errorMessage = "PDF export not implemented yet"
        return nil
    }
}