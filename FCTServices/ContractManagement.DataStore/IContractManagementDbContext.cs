namespace ContractManagement.DataStore
{
    using System.Data;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using Model;

    public interface IContractManagementDbContext
    {
        IDbSet<AtomFeedItem> AtomFeedItems { get; set; }

        IDbSet<IntegrityCheck> IntegrityCheckItems { get; set; }

        IDbSet<FundingTypeFundingPeriod> FundingTypeFundingPeriodItems { get; set; }

        IDbSet<MonthEndHistory> MonthEndHistories { get; set; }

        IDbSet<EngagementEvent> EngagementEvents { get; }

        IDbSet<FundingTypePeriodFundingStreamPeriod> FundingTypePeriodFundingStreamPeriodItems { get; set; }

        IDbSet<CdaReportFundingStreamPeriod>  CdaReportFundingStreamPeriods { get; }

        IDbSet<CdaExtract> CdaExtracts { get; }

        IDbSet<ApprovedContract> ApprovedContracts { get; }

        IDbSet<ApprovedContractAllocation> ApprovedContractAllocations { get; }

        IDbSet<RoatpProvider> RoatpProviders { get; }

        IDbSet<ProcessedMessage> ProcessedMessages { get; }

        IDbSet<ContractType> ContractTypes { get; }

        IDbSet<RegionType> RegionTypes { get; }

        IDbSet<FundingStreamPeriodLegalDeliverable> FundingStreamPeriodLegalDeliverables { get; }

        IDbSet<FundingTypeFundingPeriodContractType> FundingTypeFundingPeriodContractTypes { get; }

        IDbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }
        
        int ExecuteSql(string sqlCommand);

        Task<int> ExecuteSqlAsync(string sqlCommand);

        int SaveChanges();

        IDbConnection Connection { get; }
    }
}
