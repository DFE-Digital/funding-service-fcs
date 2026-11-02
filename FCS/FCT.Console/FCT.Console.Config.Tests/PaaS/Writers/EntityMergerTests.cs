namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class EntityMergerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EntityMerger_ShouldUpdateNonKeyValues()
        {
            // arrange
            FundingStream fundingStreamSource = new FundingStream
            {
                Code = "16-18 APPS",
                AgencyCode = "Some Agency_S",
                FinanceShortCode = "FSC_S",
                Name = "NAME_S"
            };

            FundingStream fundingStreamDestination = new FundingStream
            {
                Code = "16-18 Apps",
                AgencyCode = "Some Agency",
                FinanceShortCode = "FSC_D",
                Name = "NAME_D"
            };


            // act
            EntityMerger<FundingStream>.MergeNonKeyProperties(fundingStreamSource, fundingStreamDestination);

            // assert
            Assert.AreEqual("16-18 Apps", fundingStreamDestination.Code, "The Key has changed");
            Assert.AreEqual(fundingStreamSource.Name, fundingStreamDestination.Name, "The Name has not changed");
            Assert.AreEqual(fundingStreamSource.AgencyCode, fundingStreamDestination.AgencyCode, "The AgencyCode has not changed");
            Assert.AreEqual(fundingStreamSource.FinanceShortCode, fundingStreamDestination.FinanceShortCode, "The FinanceShortCode has not changed");
        }
    }
}
