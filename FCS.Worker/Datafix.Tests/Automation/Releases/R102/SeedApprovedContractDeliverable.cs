namespace Datafix.Tests.Automation.Releases.R102
{
    using System.Linq;
    using System.Threading.Tasks;
    using Datafix.Tests.Repositories;
    using MoreLinq;
    
    public class SeedApprovedContractDeliverable : IApplyDataFix
    {
        public string Release => "R102";
        public int StoryNumber => 34204;
        public string Name => "Release R102 - populate missing approved contract deliverables";
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
