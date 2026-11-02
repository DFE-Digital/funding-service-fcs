namespace SFA.FCT.Operations.Integrity.Services
{
    public class IntegrityCheckResult
    {
        public IntegrityCheckResult(bool foundIssues, string issuesCsv)
        {
            FoundIssues = foundIssues;
            IssuesCsv = issuesCsv;
        }

        public IntegrityCheckResult(bool foundIssues, string issuesCsv, long changeTrackingCurrentVersion) :this(foundIssues, issuesCsv)
        {
            ChangeTrackingCurrentVersion = changeTrackingCurrentVersion;
        }

        public bool FoundIssues { get; }
        
        public string IssuesCsv { get; }

        public long? ChangeTrackingCurrentVersion { get; }

        public bool IsChangeTrackingUsedAndNoIssues => ChangeTrackingCurrentVersion.HasValue && !FoundIssues;
    }
}
