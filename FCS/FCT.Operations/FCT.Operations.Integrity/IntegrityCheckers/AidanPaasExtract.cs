namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using ContractManagement.DataStore;

    public class AidanPaasExtract : PaasExtractIntegrityChecker<AidanPaasExtract.ExtractRow>
    {
        public AidanPaasExtract(ContractManagementDbContext dbContext)
            : base(dbContext)
        {
        }

        protected override string SqlResourceName => @"SFA.FCT.Operations.Integrity.IntegrityCheckers.Sql.AidanPaasExtract.sql";

        public class ExtractRow
        {
            public string FundingStreamPeriodCode { get; set; }

            public string Ukprn { get; set; }

            public string ContractAllocationNumber { get; set; }

            public string ContractNumber { get; set; }

            public DateTime AllocationStartDate { get; set; }

            public DateTime? AllocationEndDate { get; set; }

            public int ContractVersionNumber { get; set; }

            public string ContractStatus { get; set; }

            public int DeliverableCode { get; set; }

            public int? ParentDeliverableCode { get; set; }

            public decimal? PlannedValue { get; set; }

            public int? ActualVolume { get; set; }

            public decimal? ActualValue { get; set; }

            public decimal? ProfilePaymentAmount { get; set; }

            public decimal? BalancingPaymentAmount { get; set; }

            public decimal? ReconciliationPaymentAmount { get; set; }

            public decimal? CappedPaymentAmount { get; set; }

            public decimal? NetPaymentAmount { get; set; }

            public string DeliverableYear { get; set; }

            public string DeliverablePeriod { get; set; }

            public string FinancialYear { get; set; }

            public int? SubNominalProfile { get; set; }

            public int? SubNominalReconcilliation { get; set; }

            public int? SubNominalCapping { get; set; }

            public DateTime ExecutionTimeUtc { get; set; }
        }
    }
}
