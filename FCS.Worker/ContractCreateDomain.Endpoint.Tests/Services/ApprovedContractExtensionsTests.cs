namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ApprovedContractExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractExtensions_ToApprovedContractInfo_ShouldTransformValuesAsExpected()
        {
            // arrange
            ApprovedContract approvedContract = new ApprovedContract(
                "MAIN-1234",
                1,
                2,
                "AEB",
                "AY1920",
                12345,
                "ORG0012345",
                "ESFA-1234",
                new DateTime(2019, 08, 01),
                new DateTime(2020, 07, 31))
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = "AEB-1234",
                        TotalPlannedValue = 500m,
                        PlannedValueEnvelope1 = 150m,
                        PlannedValueEnvelope2 = 350m,
                        FundingStreamPeriodCode = "AEB-TOL",
                        ApprovedContractDeliverables = new List<ApprovedContractDeliverable>
                        {
                            new ApprovedContractDeliverable("ALLOC-1", 1, 100m, 25m, 75m),
                            new ApprovedContractDeliverable("ALLOC-1", 2, 0m, null, null),
                        }
                    }
                }
            };

            // act
            ApprovedContractInfo transformedContractDto = approvedContract.ToApprovedContractInfo();

            // assert
            Assert.IsNotNull(transformedContractDto, "Returned value was null");

            Assert.AreEqual("MAIN-1234", transformedContractDto.ContractNumber, "ContractNumber not transformed correctly");
            Assert.AreEqual("ESFA-1234", transformedContractDto.MasterContractNumber, "MasterContractNumber not transformed correctly");
            Assert.AreEqual(new DateTime(2019, 08, 01), transformedContractDto.StartDate, "StartDate not transformed correctly");
            Assert.AreEqual(new DateTime(2020, 07, 31), transformedContractDto.EndDate, "EndDate not transformed correctly");

            Assert.IsNotNull(transformedContractDto.Allocations, "Returned Allocations property was null");
            Assert.AreEqual(1, transformedContractDto.Allocations.Count, "Unexpected number of allocations returned");

            ApprovedContractAllocationInfo transformedAllocationDto = transformedContractDto.Allocations.Single();
            Assert.AreEqual("AEB-1234", transformedAllocationDto.ContractAllocationNumber, "ContractAllocationNumber not transformed correctly");
            Assert.AreEqual("AEB-TOL", transformedAllocationDto.FundingStreamPeriodCode, "FundingStreamPeriodCode not transformed correctly");
            Assert.AreEqual(150m, transformedAllocationDto.PlannedValueEnvelope1, "PlannedValueEnvelope1 not transformed correctly");
            Assert.AreEqual(350m, transformedAllocationDto.PlannedValueEnvelope2, "PlannedValueEnvelope2 not transformed correctly");
            Assert.AreEqual(500m, transformedAllocationDto.TotalPlannedValue, "TotalPlannedValue not transformed correctly");
            
            Assert.IsNotNull(transformedAllocationDto.Deliverables, "Returned Deliverables property was null");
            Assert.AreEqual(2, transformedAllocationDto.Deliverables.Count, "Unexpected number of deliverables returned");

            ApprovedContractDeliverableInfo transformedDeliverableDto = transformedAllocationDto.Deliverables.Single(d => d.DeliverableCode == 1);
            Assert.AreEqual(100m, transformedDeliverableDto.TotalPlannedValue, "TotalPlannedValue was not transformed correctly");
            Assert.AreEqual(25m, transformedDeliverableDto.PlannedValueEnvelope1, "PlannedValueEnvelope1 was not transformed correctly");
            Assert.AreEqual(75m, transformedDeliverableDto.PlannedValueEnvelope2, "PlannedValueEnvelope2 was not transformed correctly");

            ApprovedContractDeliverableInfo transformedDeliverableWithNullsDto = transformedAllocationDto.Deliverables.Single(d => d.DeliverableCode == 2);
            Assert.AreEqual(0m, transformedDeliverableWithNullsDto.TotalPlannedValue, "TotalPlannedValue was not transformed correctly");
            Assert.IsNull(transformedDeliverableWithNullsDto.PlannedValueEnvelope1, "PlannedValueEnvelope1 was not transformed correctly");
            Assert.IsNull(transformedDeliverableWithNullsDto.PlannedValueEnvelope2, "PlannedValueEnvelope2 was not transformed correctly");
        }
    }
}
