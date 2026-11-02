namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure.Extensions;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentInstruction;

    public static class ReportedPaymentInstructionTransformer
    {
        public static PaymentInstructionAudit TransformToPaymentInstructionAudit(EnrichedReportedActual reportedPaymentInstruction, IDate dateProvider)
        {
            return new PaymentInstructionAudit
            {
                CollectionReturnPeriod = int.Parse(dateProvider.GetCurrentPeriod(dateProvider.GetCalculationDate())),
                OrganisationId = reportedPaymentInstruction.OrganisationId,
                FundingStreamPeriodCode = reportedPaymentInstruction.FundingStreamPeriodCode,
                DeliverableCode = int.Parse(reportedPaymentInstruction.EnrichedDeliverableCode),
                Period = reportedPaymentInstruction.Period,
                ContractAllocationNumber = reportedPaymentInstruction.ContractAllocationNumber,
                Ukprn = reportedPaymentInstruction.Ukprn,
                ContractNumber = reportedPaymentInstruction.ContractNumber,
                ContractVersion = reportedPaymentInstruction.ContractVersion,
                ContractSubVersion = reportedPaymentInstruction.ContractSubVersion,
                AllocationStartDate = reportedPaymentInstruction.AllocationStartDate,
                CollectionReturnCode = reportedPaymentInstruction.CollectionReturnCode,
                CollectionType = reportedPaymentInstruction.CollectionType,
                PaymentValue = Convert.ToDecimal(reportedPaymentInstruction.ActualValue)
            };
        }

        public static IReadOnlyCollection<AllocationPaymentInstruction> TransformToAllocationPaymentInstructions(IEnumerable<EnrichedReportedActual> enrichedPaymentInstructions)
        {
            return enrichedPaymentInstructions
                .GroupBy(pi => pi.ContractAllocationNumber)
                .Select(grp => new
                {
                    FirstPaymentInstruction = grp.First(),
                    AllocationNumber = grp.Key,
                    PaymentInstructions = grp
                })
                .Select(allocation => new AllocationPaymentInstruction
                {
                    AllocationNumber = allocation.AllocationNumber,
                    VersionNumber = allocation.FirstPaymentInstruction.ContractVersion,
                    ContractNumber = allocation.FirstPaymentInstruction.ContractNumber,
                    FundingStreamPeriodCode = allocation.FirstPaymentInstruction.FundingStreamPeriodCode,
                    OrganisationId = allocation.FirstPaymentInstruction.OrganisationId,
                    Ukprn = int.Parse(allocation.FirstPaymentInstruction.Ukprn),
                    AllocationStartDate = allocation.FirstPaymentInstruction.AllocationStartDate,
                    AllocationEndDate = allocation.FirstPaymentInstruction.AllocationEndDate != DateTime.MinValue ? allocation.FirstPaymentInstruction.AllocationEndDate : (DateTime?)null,
                    DeliverablePaymentInstructions = allocation.PaymentInstructions.Select(pi => new DeliverablePaymentInstruction
                    {
                        DeliverableCode = int.Parse(pi.EnrichedDeliverableCode),
                        Period = pi.Period,
                        PeriodTypeCode = pi.PeriodTypeCode,
                        PaymentValue = (decimal)pi.ActualValue
                    }).ToList()
                })
                .ToList();
        }
    }
}