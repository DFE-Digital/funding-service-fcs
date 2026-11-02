namespace FCT.Operations.Cda.Dtos
{
    using System.Collections.Generic;

    public class Report
    {
        public Report(IReadOnlyCollection<CdaRow> rows, string reportName, bool isArchiveClosedContractReport = false)
        {
            Rows = rows;
            ReportName = reportName;
            IsArchiveClosedContractReport = isArchiveClosedContractReport;
        }

        public IReadOnlyCollection<CdaRow> Rows { get; }

        public string ReportName { get; }
        public bool IsArchiveClosedContractReport { get; }
        public int? ArchivedYear { get; set; }

        public override string ToString()
        {
            return
                $"ReportName: {ReportName}, IsArchiveClosedContractReport: {IsArchiveClosedContractReport}, ArchivedYear: {ArchivedYear}, Row count: {Rows.Count}";
        }
    }
}
