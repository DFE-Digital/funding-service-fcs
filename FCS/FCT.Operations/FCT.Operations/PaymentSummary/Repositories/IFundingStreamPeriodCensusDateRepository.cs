namespace FCT.Operations.PaymentSummary.Repositories
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodCensusDateRepository
    {
        Task<bool> HaveAllPaidCensusDatesPassedForCensusPeriod(DateTime currentTime, ConnectionInfo connectionInfo);
    }
}
