namespace Datafix.Tests.Automation.Releases.R95
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Datafix.Tests.Extensions;
    using Datafix.Tests.Repositories;
    using Dtos;
    using MoreLinq;

    public class SeedApprovedContractDeliverable : IApplyDataFix
    {
        public string Release => "R95";

        public int StoryNumber => 30464;

        public string Name => "Seed the Approved Contract Deliverable table";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var approvedContractAllocationIdentifiers = ApprovedContractRepository.GetApprovedContractAllocationIdentifiersWithIncludeSoF();

            approvedContractAllocationIdentifiers.Batch(2).ForEach(batch =>
            {
                var tasks = batch.Select(ProcessContractAllocationIdentifier);

                Task.WaitAll(tasks.ToArray());
            });
        }

        private async Task ProcessContractAllocationIdentifier(
            ApprovedContractAllocationIdentifier approvedContractAllocationIdentifier)
        {
            var deliverablePayments = await DeliverablePaymentRepository.GetPlannedValueLines(
                approvedContractAllocationIdentifier.AllocationNumber,
                approvedContractAllocationIdentifier.VersionNumber);

            if (deliverablePayments.Any())
            {
                int startYear = deliverablePayments.GetStartYear();
                int endYear = deliverablePayments.GetEndYear();

                var deliverables = deliverablePayments.GroupBy(dp => dp.DeliverableCode).ToList()
                    .Select(deliverablePaymentsForDeliverable =>
                    {
                        var totalPlannedValue = deliverablePaymentsForDeliverable.Sum(dp => dp.PlannedValue);

                        var envelope1 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                            ? deliverablePaymentsForDeliverable.GetFirstEnvelope(startYear)
                            : (decimal?)null;

                        var envelope2 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                            ? deliverablePaymentsForDeliverable.GetSecondEnvelope(endYear)
                            : (decimal?)null;

                        return new ApprovedContractDeliverable(
                            approvedContractAllocationIdentifier.AllocationNumber,
                            approvedContractAllocationIdentifier.ApprovedContractId,
                            deliverablePaymentsForDeliverable.Key,
                            totalPlannedValue,
                            envelope1,
                            envelope2);
                    }).ToList();

                await ApprovedContractRepository.InsertApprovedContractDeliverables(deliverables);
            }
        }
    }
}
