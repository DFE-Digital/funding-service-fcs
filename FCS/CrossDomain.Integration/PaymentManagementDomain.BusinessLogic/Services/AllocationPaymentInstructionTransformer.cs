namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentInstruction;
    using PaymentSchedule.DataStore.Model;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public static class AllocationPaymentInstructionTransformer
    {
        public static PaymentSchedule.Allocation ToPaymentSchedule(AllocationPaymentInstruction allocationPaymentInstruction)
        {
            return new PaymentSchedule.Allocation
            {
                AllocationNumber = allocationPaymentInstruction.AllocationNumber,
                ContractNumber = allocationPaymentInstruction.ContractNumber,
                VersionNumber = allocationPaymentInstruction.VersionNumber,
                ContractVersionNumber = allocationPaymentInstruction.VersionNumber,
                FundingStreamPeriodCode = allocationPaymentInstruction.FundingStreamPeriodCode,
                Organisation = new PaymentSchedule.Organisation
                {
                    MainOrganisationIdentifier = allocationPaymentInstruction.OrganisationId,
                    OrganisationIdentifiers = new List<PaymentSchedule.OrganisationIdentifier>
                    {
                        new PaymentSchedule.OrganisationIdentifier
                        {
                            OrganisationId = allocationPaymentInstruction.Ukprn.ToString(),
                            OrganisationIdentifierName = PaymentSchedule.OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
                },
                AllocationDeliverables = allocationPaymentInstruction.DeliverablePaymentInstructions.Select(dpi => new PaymentSchedule.AllocationDeliverable
                {
                    DeliverableCode = dpi.DeliverableCode,
                    ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                    {
                        new PaymentSchedule.ScheduledPayment
                        {
                            Period = dpi.Period,
                            PeriodTypeCode = dpi.PeriodTypeCode,
                            ReconciliationPaymentAmount = dpi.PaymentValue,
                            NetPaymentAmount = dpi.PaymentValue
                        }
                    }
                }).ToList()
            };
        }

        public static IReadOnlyCollection<DeliverablePayment> ToDeliverablePayments(AllocationPaymentInstruction allocationPaymentInstruction)
        {
            return allocationPaymentInstruction.DeliverablePaymentInstructions.Select(dpi => new DeliverablePayment
            {
                AllocationNumber = allocationPaymentInstruction.AllocationNumber,
                VersionNumber = allocationPaymentInstruction.VersionNumber,
                DeliverableCode = dpi.DeliverableCode,
                Period = dpi.Period,
                PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), dpi.PeriodTypeCode),
                ReconciliationPaymentAmount = dpi.PaymentValue,
                NetPaymentAmount = dpi.PaymentValue,
                PlannedVolume = 0,
                PlannedValue = 0M,
                ProfilePaymentAmount = 0M,
                CappedPaymentAmount = 0M,
                BalancingPaymentAmount = 0M,
                ActualValue = 0M,
                ActualVolume = null,
                CollectionReturnCode = null
        }).ToList();
        }
    }
}
