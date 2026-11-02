namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System.Collections.Generic;
    using DTOs;
    using PaymentAggregation = CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IContractDeliverablePeriodPresenceChecker
    {
        bool AreAllRequiredContractDeliverablePeriodsPresent(PaymentAggregation.Allocation allocation, IEnumerable<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods);

        bool AreAllRequiredContractDeliverablePeriodsPresent(PaymentSchedule.Allocation allocation, IEnumerable<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods);
    }
}
