namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories
{
    using System.Collections.Generic;
    using DTOs;

    public interface IContractDeliverablePeriodRepository
    {
        IReadOnlyCollection<ContractDeliverablePeriodInfo> GetContractDeliverablePeriodsForAllocation(string allocationNumber);
    }
}
