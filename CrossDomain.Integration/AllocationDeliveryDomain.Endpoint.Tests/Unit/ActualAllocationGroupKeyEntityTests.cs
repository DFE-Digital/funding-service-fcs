namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class ActualAllocationGroupKeyEntityTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ActualAllocationGroupKeyEntity_ShouldOnlyAddOneItemToSetWhenItemsAreEqual()
        {
            // arrange
            ReportedActual reportedActual = new ReportedActual
            {
                CollectionType = "TT",
                CollectionReturnCode = "RR",
                ActualValue = 0,
                OrganisationId = "12345678",
                FundingStreamPeriodCode = "fspc",
                UoPCode = "uop"
            };

            HashSet<ActualAllocationGroupKeyEntity> entitySet = new HashSet<ActualAllocationGroupKeyEntity>();

            // act
            entitySet.Add(ActualAllocationGroupKeyEntity.CreateFromReportedActual(reportedActual));
            entitySet.Add(ActualAllocationGroupKeyEntity.CreateFromReportedActual(reportedActual));

            // assert
            Assert.AreEqual(entitySet.Count, 1, "The equals override on ActualAllocationGroupKeyEntity has not worked");
        }
    }
}
