namespace FCT.Operations.Cda.Dtos
{
    using System;
    using System.Collections.Generic;

    public class CdaExtract
    {
        public CdaExtract(string extractName)
        {
            ExtractName = extractName;
        }

        public string ExtractName { get; private set; }

        public DateTime? ReportingCloseDate { get; set; }
        public bool ArchiveClosedContracts { get; set; }

        public virtual ICollection<CdaReportFundingStreamPeriod> CdaReportFundingStreamPeriods { get; set; }
    }
}
