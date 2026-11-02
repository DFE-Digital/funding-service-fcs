namespace FCT.Operations.FundingConfirmationReport.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ILAFundingConfirmationReportRepository
    {
        //Task<int> GetLALatestPeriodFromConfig(ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<FspInfo>> GetLAFspInfos(IReadOnlyCollection<int> ukprns, int startPeriod,
            int endPeriod,
             ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetLADeliverablePaymentInfosForPoP(
            IReadOnlyCollection<int> ukprns,
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo);
       

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetLADeliverablePaymentInfosForPoAForFinancialYear(
             IReadOnlyCollection<int> ukprns,
             IReadOnlyCollection<string> fspCodes,
              int startPeriod,
              int endPeriod,
             ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<UkprnInfo>> GetLAUkprnsForPeriod(int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetLADeliverablePaymentInfosForPoAForALAPNLAP(
                IReadOnlyCollection<int> ukprns,
                IReadOnlyCollection<string> fspCodes,
                int startPeriod,
                int endPeriod,
                ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<NetPaymentInfo>> GetLANetPaymentInfosForPayOnInstruction(
            IReadOnlyCollection<int> ukprns,
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo);
    }
}