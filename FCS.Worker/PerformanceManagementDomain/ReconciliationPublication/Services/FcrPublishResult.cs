namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;

    public class FcrPublishResult
    {
        public FcrPublishResult(bool isAtomFeedDuplicate, DateTime publishedDate, ContractInfo contractInfo)
        {
            IsAtomFeedDuplicate = isAtomFeedDuplicate;
            PublishedDate = publishedDate;
            ContractInfo = contractInfo;
        }

        public bool IsAtomFeedDuplicate { get; }

        public DateTime PublishedDate { get; }

        public ContractInfo ContractInfo { get; }
    }
}
