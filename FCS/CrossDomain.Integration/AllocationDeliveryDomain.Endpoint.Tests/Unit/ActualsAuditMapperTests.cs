namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic.Mapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ActualsAuditMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Map_ShouldMarshallParentDeliverableCodeAndCollectionPeriod_ForeachReportedActual()
        {
            // arrange
            var mockStore = new Mock<IFundingStreamConfigurationStore>();
            var expectedCollectionReturnPeriod = Convert.ToInt32(DateTime.UtcNow.AddMonths(-1).ToString("yyyyMM"));
            var deliverables = new List<FundingStreamPeriodDeliverable>
                {
                    new FundingStreamPeriodDeliverable
                    {
                        FundingStreamPeriodCode = "1",
                        DeliverableCode = 9,
                        ParentDeliverableCode = 5
                    },

                    new FundingStreamPeriodDeliverable
                    {
                        FundingStreamPeriodCode = "2",
                        DeliverableCode = 10,
                        ParentDeliverableCode = 6
                    },
                };
            mockStore.Setup(m => m.GetFundingStreamPeriodDeliverables(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(deliverables);

            string allocation1 = Guid.NewGuid().ToString();
            string allocation2 = Guid.NewGuid().ToString();
            string fundingStreamPeriod1 = "1";
            string fundingStreamPeriod2 = "2";
            string deliverableCode1 = "9";
            string deliverableCode2 = "10";
            var actual1 = new EnrichedReportedActual { ContractAllocationNumber = allocation1, FundingStreamPeriodCode = fundingStreamPeriod1, ActualValue = 10, DeliverableCode = deliverableCode1 };
            var actual2 = new EnrichedReportedActual { ContractAllocationNumber = allocation2, FundingStreamPeriodCode = fundingStreamPeriod2, ActualValue = 20, DeliverableCode = deliverableCode2 };


            var actuals = new List<EnrichedReportedActual> { actual1, actual2 };
            // act
            var mapper = new ActualsAuditMapper(mockStore.Object, new SystemDate());
            var result = mapper.Map(actuals, ConnectionInfo.CreateDefault()).ToList();

            // Assert
            Assert.AreEqual(2, result.Count);
            Assert.IsInstanceOfType(result[0].DeliverableCode, typeof(int));
            Assert.IsInstanceOfType(result[1].DeliverableCode, typeof(int));
            Assert.AreEqual(5, result[0].ParentDeliverableCode);
            Assert.AreEqual(6, result[1].ParentDeliverableCode);
            Assert.AreEqual(expectedCollectionReturnPeriod, result[0].CollectionReturnPeriod);
            Assert.AreEqual(expectedCollectionReturnPeriod, result[1].CollectionReturnPeriod);

        }
    }
}
