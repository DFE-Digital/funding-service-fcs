
namespace ContractRequestDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    public class DasRequestTransformerTests
    {
        [TestMethod]
        [TestCategory("UnitTest")]
        public void DasRequestTransformer_ShouldTransformValidContractRequest()
        {
            // Arrange
            var incomingRequest = new DasRequest
            {
                FundingType = "LEVY",
                StartDate = new DateTime(2017, 1, 1),
                Ukprn = 10033670
            };

            // Act
            var actualRequest = DasRequestTransformer.Transform(incomingRequest);

            // Remove correlation detail (not deterministic in tests)
            actualRequest.correlationInfo = null;
            actualRequest.contract.correlationId = null;
            actualRequest.contract.contracts[0].correlationId = null;
            actualRequest.contract.contracts[0].contractAllocations[0].correlationId = null;

            // Assert
            using (var resource = new TestResource("ContractRequestDomain.Tests", @"Resources.contract_request_das.json"))
            using (var sr = new StreamReader(resource.Stream))
            {
                var expected = JsonConvert.DeserializeObject<contractRequestType>(sr.ReadToEnd());

                // Some properties apparently not hydrated from JSON in your test data
                expected.contract.hierarchyType = hierarchyType.MASTERCONTRACT;
                expected.contract.contracts[0].hierarchyType = hierarchyType.CONTRACT;

                expected.correlationInfo = null;
                expected.contract.correlationId = null;
                expected.contract.contracts[0].correlationId = null;
                expected.contract.contracts[0].contractAllocations[0].correlationId = null;

                // Deep compare with FluentAssertions, ignoring known noise
                actualRequest.Should().BeEquivalentTo(
                    expected,
                    opts => opts
                        // ignore fields you scrubbed to null
                        .Excluding(x => x.correlationInfo)
                        .Excluding(x => x.contract.correlationId)
                        .Excluding(x => x.contract.contracts[0].correlationId)
                        .Excluding(x => x.contract.contracts[0].contractAllocations[0].correlationId)
                        // optional: if the JSON vs runtime kind differs
                        .Using<DateTime>(ctx => ctx.Subject.ToUniversalTime()
                            .Should().Be(ctx.Expectation.ToUniversalTime()))
                            .WhenTypeIs<DateTime>()
                );
            }
        }
    }
}
