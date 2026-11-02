namespace ContractRequestDomain.Cfs.Tests.Enrich
{
    using System.Linq;
    using Cfs.Enrich;
    using Commands;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class EnrichAllocationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnrichAllocationHandler_ShouldEnrichAllocationWithExpectedValues()
        {
            // arrange
            Allocation allocationToEnrich = new Allocation();

            EnrichAllocationHandler handler = new EnrichAllocationHandler(Mock.Of<ILogger>());
            TestableMessageHandlerContext handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new EnrichAllocationCommand { Allocation = allocationToEnrich }, handlerContext).Wait();

            // assert
            Assert.AreEqual(1, handlerContext.SentMessages.Length, "Unexpected number of messages sent");
            Assert.IsInstanceOfType(handlerContext.SentMessages.Single().Message, typeof(CreateAllocationCommand), "Unexpected message type sent");

            Allocation enrichedAllocation = ((CreateAllocationCommand)handlerContext.SentMessages.Single().Message).Allocation;

            Assert.AreEqual("ALLF1819", enrichedAllocation.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode on enriched allocation");
            Assert.AreEqual(5, enrichedAllocation.DeliverableCode, "Incorrect DeliverableCode on enriched allocation");
            Assert.AreEqual("LOANS", enrichedAllocation.FundingTypeCode, "Incorrect FundingTypeCode on enriched allocation");
            Assert.AreEqual("AY1819", enrichedAllocation.FundingPeriod, "Incorrect FundingPeriod on enriched allocation");
        }
    }
}
