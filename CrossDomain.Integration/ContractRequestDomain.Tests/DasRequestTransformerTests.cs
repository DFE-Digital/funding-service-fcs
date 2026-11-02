namespace ContractRequestDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Microsoft.Test.ObjectComparison;
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
            DasRequest incomingRequest = new DasRequest
            {
                FundingType = "LEVY",
                StartDate = new DateTime(2017, 1, 1),
                Ukprn = 10033670
            };

            // Act
            contractRequestType actualRequest = DasRequestTransformer.Transform(incomingRequest);

            // Remove correlation detail
            actualRequest.correlationInfo = null;
            actualRequest.contract.correlationId = null;
            actualRequest.contract.contracts[0].correlationId = null;
            actualRequest.contract.contracts[0].contractAllocations[0].correlationId = null;

            // Assert
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.contract_request_das.json"))
            {
                using (StreamReader sr = new StreamReader(resource.Stream))
                {
                    contractRequestType expected = JsonConvert.DeserializeObject<contractRequestType>(sr.ReadToEnd());

                    // hand crafting some props that don't seem to be read properly from JSON
                    expected.contract.hierarchyType = hierarchyType.MASTERCONTRACT;
                    expected.contract.contracts[0].hierarchyType = hierarchyType.CONTRACT;
                    expected.correlationInfo = null;
                    expected.contract.correlationId = null;
                    expected.contract.contracts[0].correlationId = null;
                    expected.contract.contracts[0].contractAllocations[0].correlationId = null;

                    // get errors
                    IReadOnlyCollection<ObjectComparisonMismatch> errors = ObjectComparison.CompareObjects(expected, actualRequest);

                    var mismatches = errors.WriteMismatches().Split('\n').Where(m => !m.Contains("RootObject.FundingConfiguration.Capacity") && !m.Contains("hierarchyType value: MASTERCONTRACT") && !m.Contains("startDate.Kind value: Utc")).ToList();

                    // ignoring erroneous mismatches
                    if (mismatches.Any(m => !string.IsNullOrEmpty(m)))
                    {
                        Assert.Fail(string.Concat(mismatches.Select(m => $"{m}\r\n")));
                    }
                }
            }
        }
    }
}