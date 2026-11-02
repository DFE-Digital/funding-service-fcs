namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodQueryRepository
    {
        Task<IReadOnlyCollection<string>> GetPayOnProfileFundingStreamPeriodCodes(IReadOnlyCollection<string> fspCodes, ConnectionInfo connectionInfo);
    }
}