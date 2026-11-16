namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using UnitTests.Common;

    [TestClass]
    public class EsaAllocationAggregatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EsaAllocationAggregator_ShouldAggregateUpDeliverablePeriodValues()
        {
            // arrange
            Contract contract = GetCorporateContract();

            // act
            IReadOnlyCollection<contractAllocationsContractAllocation> aggregatedAllocations =
                EfaAllocationAggregator.AggregateDeliverablePeriodValueWithTheSameFsp(contract.contractAllocations);

            // assert
            Assert.AreEqual(3, aggregatedAllocations.Count);
            decimal plannedValue = aggregatedAllocations.Single(a => a.fundingStreamPeriodCode == "1619LR1718")
                .contractDeliverables.Single(dp => dp.deliverable.deliverableCode == 24)
                .contractDeliverablePeriods.Single(cdp => cdp.period == 8 && cdp.year == 2017).plannedValue;

            Assert.AreEqual(-3921.87M, plannedValue, "The value for deliverable code: 24, FSP: 1619LR1718 anf period: 8 is incorrect");

            plannedValue = aggregatedAllocations.Single(a => a.fundingStreamPeriodCode == "1619LR1718")
               .contractDeliverables.Single(dp => dp.deliverable.deliverableCode == 19)
               .contractDeliverablePeriods.Single(cdp => cdp.period == 1 && cdp.year == 2018).plannedValue;

            Assert.AreEqual(1539.43M, plannedValue, "The value for deliverable code: 19, FSP: 1619LR1718 anf period: 1 is incorrect");

            plannedValue = aggregatedAllocations.Single(a => a.fundingStreamPeriodCode == "NMF1718")
              .contractDeliverables.Single(dp => dp.deliverable.deliverableCode == 39)
              .contractDeliverablePeriods.Single(cdp => cdp.period == 1 && cdp.year == 2018).plannedValue;

            Assert.AreEqual(4718.93M, plannedValue, "The value for deliverable code: 39, FSP: NMF1718 anf period: 1 is incorrect");

            plannedValue = aggregatedAllocations.Single(a => a.fundingStreamPeriodCode == "NMF1718")
           .contractDeliverables.Single(dp => dp.deliverable.deliverableCode == 43)
           .contractDeliverablePeriods.Single(cdp => cdp.period == 1 && cdp.year == 2018).plannedValue;

            Assert.AreEqual(12175.44M, plannedValue, "The value for deliverable code: 43, FSP: NMF1718 anf period: 1 is incorrect");
        }

        private Contract GetCorporateContract()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.corpContractEfa.json"))
            {
                return
                    (Contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(Contract));
            }
        }
    }
}
