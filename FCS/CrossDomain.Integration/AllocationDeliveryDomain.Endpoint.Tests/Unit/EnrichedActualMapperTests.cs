using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class EnrichedActualMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Map_ShouldMarshalPropertiesFromReportedActualToContractAllocationsActuals_ForeachReportedActual()
        {
            // arrange
            var rng = new Random();
            string allocation1 = Guid.NewGuid().ToString();
            string allocation2 = Guid.NewGuid().ToString();
            string fundingStreamPeriod1 = "1";
            string fundingStreamPeriod2 = "2";
            string deliverableCode = "9";
            string collectionReturnCode = Guid.NewGuid().ToString();
            var actual1 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod1, ActualValue = 10, CollectionReturnCode = collectionReturnCode, DeliverableCode = deliverableCode, PeriodTypeCode = Guid.NewGuid().ToString(), ContractNumber = "1", ContractVersion =2, ContractSubVersion = 3};
            var actual2 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod1, ActualValue = 20, CollectionReturnCode = collectionReturnCode, };
            var actual3 = new EnrichedReportedActual { ContractAllocationNumber = allocation2, FundingStreamPeriodCode = fundingStreamPeriod1, ActualValue = 30, CollectionReturnCode = collectionReturnCode, };
            var actual4 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod2, ActualValue = 40, CollectionReturnCode = collectionReturnCode, };

            var actuals = new List<EnrichedReportedActual>{actual1, actual2, actual3, actual4};
            // act
            var mapper = new EnrichedActualMapper();
            var result = mapper.Map(actuals).ToList();

            // Assert
            Assert.AreEqual(3, result.Count);
            Assert.AreEqual(2, result[0].ActualsSummary.Count);
            Assert.AreEqual(allocation1, result[0].ContractAllocationNumber);
            Assert.AreEqual(fundingStreamPeriod1, result[0].FundingStreamPeriodCode);
            Assert.AreEqual((decimal)actual1.ActualValue, result[0].ActualsSummary[0].ActualValue);
            Assert.AreEqual((decimal)actual2.ActualValue, result[0].ActualsSummary[1].ActualValue);

            Assert.AreEqual(1, result[1].ActualsSummary.Count);
            Assert.AreEqual(allocation2, result[1].ContractAllocationNumber);
            Assert.AreEqual(fundingStreamPeriod1, result[1].FundingStreamPeriodCode);
            Assert.AreEqual((decimal)actual3.ActualValue, result[1].ActualsSummary[0].ActualValue);

            Assert.AreEqual(1, result[2].ActualsSummary.Count);
            Assert.AreEqual(allocation1, result[2].ContractAllocationNumber);
            Assert.AreEqual(fundingStreamPeriod2, result[2].FundingStreamPeriodCode);
            Assert.AreEqual((decimal)actual4.ActualValue, result[2].ActualsSummary[0].ActualValue);

            var mappedActual1 = result[0].ActualsSummary[0];
            Assert.AreEqual(int.Parse(deliverableCode), mappedActual1.DeliverableCode);
            Assert.AreEqual(actual1.PeriodTypeCode, mappedActual1.PeriodType.PeriodTypeCode);
            Assert.AreEqual(actual1.ContractNumber, result[0].ContractReference.ContractNumber);
            Assert.AreEqual(actual1.ContractVersion, result[0].ContractReference.ContractVersionNumber);
            Assert.AreEqual(actual1.ContractSubVersion, result[0].ContractReference.ContractSubVersionNumber);
            Assert.AreEqual(collectionReturnCode, result[0].CollectionReturnCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnrichedActualMapper_ShouldAggregateAllocationsFromDifferentCollections()
        {
            // arrange
            string allocation1 = "ABC-123";
            string allocation2 = "DEF-456";
            string fundingStreamPeriod = "1";
            Func<string> getCollectionReturnCode = () => Guid.NewGuid().ToString();

            var actual1 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod, CollectionReturnCode = getCollectionReturnCode() };
            var actual2 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod, CollectionReturnCode = getCollectionReturnCode() };
            var actual3 = new EnrichedReportedActual { ContractAllocationNumber = allocation2, FundingStreamPeriodCode = fundingStreamPeriod, CollectionReturnCode = getCollectionReturnCode() };
            var actual4 = new EnrichedReportedActual { ContractAllocationNumber = allocation2, FundingStreamPeriodCode = fundingStreamPeriod, CollectionReturnCode = getCollectionReturnCode() };

            var actuals = new List<EnrichedReportedActual> { actual1, actual2, actual3, actual4 };

            // act
            var mapper = new EnrichedActualMapper();
            List<ContractAllocationActualsType> result = mapper.Map(actuals).ToList();

            // Assert
            Assert.AreEqual(2, result.Count, "Should reduce to only two ContractAllocationActualsTypes - despite different collection return codes");
        }
    }
}
