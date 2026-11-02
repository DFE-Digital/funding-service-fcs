namespace Datafix.Tests.Automation.Releases.R102b
{
    using System.Linq;
    using System.Threading.Tasks;
    using Datafix.Tests.Repositories;
    using MoreLinq;

    public class SeedApprovedContractDeliverablePart2 : IApplyDataFix
    {
        public string Release => "R102b";
        public int StoryNumber => 34487;
        public string Name => "Apply datafix for DaDA contracts (34487)";
        public int Order => 2;

        public void ApplyDataFix()
        {
            var approvedContractAllocationIdentifiers = ApprovedContractRepository
                .GetApprovedContractAllocationIdentifiersWithIncludeSoFWithMissingDeliverables();

            approvedContractAllocationIdentifiers.Batch(2).ForEach(batch =>
            {
                var tasks = batch.Select(ApprovedContractRepository.InsertDeliverablesForAllocation);

                Task.WaitAll(tasks.ToArray());
            });

            var approvedContractAllocationsWithMissingEnvelopeValues =
                ApprovedContractRepository.GetApprovedContractAllocationsWithMissingEnvelopeValues();

            var allocationEnvelopeValues = approvedContractAllocationsWithMissingEnvelopeValues
                .Select(ApprovedContractRepository.GetEnvelopeValuesForAllocation).ToList();

            allocationEnvelopeValues.ForEach(a =>
            {
                ApprovedContractRepository.UpdateApprovedContractAllocation(
                    a.allocationNumber,
                    a.approvedContractId,
                    a.envelope1,
                    a.envelope2);
                a.deliverbles.ForEach(d =>
                {
                    ApprovedContractRepository.UpdateApprovedContractDeliverable(a.allocationNumber, a.approvedContractId, d.deliverableCode, d.envelope1, d.envelope2);
                });
            });
        }
    }
}
