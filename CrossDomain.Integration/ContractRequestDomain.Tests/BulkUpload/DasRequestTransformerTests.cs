namespace ContractRequestDomain.Tests.BulkUpload
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class DasRequestTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Transform_CreatesLevyContractRequestFromDasRequest()
        {
            var startDate = new DateTime(2024, 8, 1, 12, 0, 0, DateTimeKind.Local);
            var dasRequest = new DasRequest
            {
                FundingType = "LEVY",
                Ukprn = 12345678,
                StartDate = startDate
            };

            var transformed = DasRequestTransformer.Transform(dasRequest);
            var contract = transformed.contract.contracts[0];
            var allocation = contract.contractAllocations[0];

            Assert.AreEqual(Intent.New, transformed.contract.CRMIntent);
            Assert.AreEqual("LEVY", contract.fundingTypeCode);
            Assert.AreEqual(12345678, contract.contractor.ukprn);
            Assert.AreEqual(startDate.ToUniversalTime(), contract.startDate);
            Assert.AreEqual("LEVY1799", allocation.fundingStreamPeriodCode);
            Assert.AreEqual("LEVY", allocation.fundingStreamCode);
            Assert.AreEqual(12345678, allocation.ukprn);
            Assert.AreEqual(1, transformed.FundingConfiguration.Count);
            Assert.AreEqual("LEVY1799", transformed.FundingConfiguration[0].FundingStreamPeriodCode);
            Assert.IsNotNull(Guid.Parse(contract.correlationId));
            Assert.IsNotNull(Guid.Parse(transformed.correlationInfo.correlationId));
        }
    }
}
