namespace FCT.Operations.FundingConfirmationReport.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingConfirmationReportRepository
    {
        //Task<int> GetLatestPeriodFromConfig(ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<FspInfo>> GetFspInfos(IReadOnlyCollection<int> ukprn, int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo);
        //Task<IReadOnlyCollection<string>> GetFundingPeriodsForPeriod(int period, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentInfosForPoP(
            IReadOnlyCollection<string> fspCodes,
              int startPeriod,
              int endPeriod,
            ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentInfosForPoAForAcademicYear(
            IReadOnlyCollection<string> fspCodes,
              int startPeriod,
              int endPeriod,
            ConnectionInfo connectionInfo);
        Task<IReadOnlyCollection<UkprnInfo>> GetUkprnsForPeriod(int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentInfosForPoAForNonAcademicYear(
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<NetPaymentInfo>> GetNetPaymentInfosForPayOnInstruction(
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo);
    }
}