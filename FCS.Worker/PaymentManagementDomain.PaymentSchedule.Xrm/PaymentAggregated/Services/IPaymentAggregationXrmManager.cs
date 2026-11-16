using System;
namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Services
{
    extern alias IntegrationEntities;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using System.Collections.Generic;

    public interface IPaymentAggregationXrmManager
    {
        void SavePaymentAggregation(Allocation allocation, IReadOnlyCollection<ContractDeliverablePeriodInfo> allDeliverablePeriodResults);
    }
}
