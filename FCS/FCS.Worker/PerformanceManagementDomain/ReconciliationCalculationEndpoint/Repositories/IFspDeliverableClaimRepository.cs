namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IFspDeliverableClaimRepository
    {
        Task<IReadOnlyCollection<FspDeliverableClaim>> GetFspDeliverablesIncludingClaimDeliverableGroup(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        Task<string> GetDeliverableName(int deliverableCode, string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverableCodeInfo>> GetDeliverableCodeInfos(string fundingStreamPeriodCode,
            ConnectionInfo connectionInfo);

        decimal GetSumOfParentDeliverablesPlannedValueForGroup(IReadOnlyCollection<DeliverableLine> deliverableLines,
            IReadOnlyCollection<DeliverableCodeInfo> deliverableCodeInfos);

        Task<IReadOnlyCollection<int>> GetProfileDeliverableCodes(string fundingStreamPeriodCode,
            ConnectionInfo connectionInfo);
    }
}