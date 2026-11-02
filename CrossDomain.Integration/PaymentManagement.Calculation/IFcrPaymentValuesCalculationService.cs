namespace PaymentManagement.Calculation
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;

    public interface IFcrPaymentValuesCalculationService
    {
        IReadOnlyCollection<Allocation> CalculateAllocationSchedules(ContractInfo contractInfo,
            ConnectionInfo connectionInfo, bool shouldStaggerPayments);
    }
}
