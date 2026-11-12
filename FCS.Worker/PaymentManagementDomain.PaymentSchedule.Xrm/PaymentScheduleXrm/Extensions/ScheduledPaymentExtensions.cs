namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services
{
    extern alias IntegrationEntities;
    using Microsoft.Xrm.Sdk;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class ScheduledPaymentExtensions
    {
        public static sfa_contractdeliverableperiod ToContractDeliverablePeriod(this ScheduledPayment scheduledPayment, EntityReference periodTypeGuid)
        {
            return new sfa_contractdeliverableperiod
            {
                sfa_name = scheduledPayment.PeriodNameDisplayFormat,
                sfa_PeriodName = scheduledPayment.PeriodNameDisplayFormat,
                sfa_PlannedValue = scheduledPayment.PlannedValue,
                sfa_PlannedVolume = scheduledPayment.PlannedVolume,
                sfa_Year = scheduledPayment.Year,
                sfa_Period = scheduledPayment.Month,
                sfa_DisplayOrder = int.Parse(scheduledPayment.Period),
                sfa_PeriodTypeId = periodTypeGuid,
                sfa_ReconciliationPaymentAmount = scheduledPayment.ReconciliationPaymentAmount,
                sfa_ProfilePaymentAmount = scheduledPayment.ProfilePaymentAmount,
                sfa_ActualValue = scheduledPayment.ActualValue,
                sfa_ActualVolume = scheduledPayment.ActualVolume,
                sfa_BalancingPaymentAmount = scheduledPayment.BalancingPaymentAmount,
                sfa_CappedPaymentAmount = scheduledPayment.CappedPaymentAmount,
                sfa_NetPaymentAmount = scheduledPayment.NetPaymentAmount
            };
        }

        public static bool IsDifferentTo(this ScheduledPayment scheduledPayment,
            sfa_contractdeliverableperiod contractDeliverablePeriod)
        {
            return scheduledPayment.ProfilePaymentAmount != contractDeliverablePeriod.sfa_ProfilePaymentAmount ||
                   scheduledPayment.ActualValue != contractDeliverablePeriod.sfa_ActualValue ||
                   scheduledPayment.ActualVolume != contractDeliverablePeriod.sfa_ActualVolume ||
                   scheduledPayment.BalancingPaymentAmount != contractDeliverablePeriod.sfa_BalancingPaymentAmount ||
                   scheduledPayment.CappedPaymentAmount != contractDeliverablePeriod.sfa_CappedPaymentAmount ||
                   scheduledPayment.NetPaymentAmount != contractDeliverablePeriod.sfa_NetPaymentAmount ||
                   scheduledPayment.ReconciliationPaymentAmount !=
                   contractDeliverablePeriod.sfa_ReconciliationPaymentAmount;
        }
    }
}
