namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using System;

    public class FundingClaimReconciliationPublishedEvent
    {
        public Guid FundingClaimReconciliationId { get; set; }

        public string FundingClaimReconciliationName { get; set; }

        public ContractInfo ContractInfo { get; set; }

        public DateTime PublishedDate { get; set; }

        public bool IsClaimCollectionPayable { get; set; }

        public bool IsForManualPublication { get; set; }

        public bool ShouldStaggerPayments { get; set; }

        public override string ToString()
        {
            return $"FundingClaimReconciliationId: {FundingClaimReconciliationId}, FundingClaimReconciliationName: {FundingClaimReconciliationName}, " +
                   $"ContractInfo: ({ContractInfo}), " +
                   $"PublishedDate: {PublishedDate.ToString("dd/MM/yyyy HH:mm:ss")}, IsClaimCollectionPayable: {IsClaimCollectionPayable}, " +
                   $"IsForManualPublication: {IsForManualPublication}, ShouldStaggerPayments: {ShouldStaggerPayments}";
        }
    }

}
