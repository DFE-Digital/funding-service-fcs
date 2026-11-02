namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using Dtos;

    public interface ICdaReportFundingStreamPeriodQueryRepository
    {
        IReadOnlyCollection<ReportConfig> GetAllWithinPublicationCloseDate(System.DateTime todaysDate);
    }
}