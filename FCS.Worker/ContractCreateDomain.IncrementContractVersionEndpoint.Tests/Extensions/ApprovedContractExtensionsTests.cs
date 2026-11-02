namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using IncrementContractVersionEndpoint.Extensions;
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


        [TestMethod, TestCategory("TechnicalExploration")]
        public void ApprovedContractExtensions_ToApprovedContractInfo_RecreateR102OatIssue()
        {
            // OAT table data
            // SELECT * FROM [ContractManagement].[ApprovedContract] where ContractNumber = 'DADAS-1002'
            // SELECT * FROM [ContractManagement].[ApprovedContractAllocation] where ApprovedContractId in (95404, 95541)
            // SELECT * FROM [ContractManagement].[ApprovedContractDeliverable]where ContractAllocationNumber = 'DADA-1002'

            // arrange
            ApprovedContract approvedContract = new ApprovedContract(
                "DADAS-1002",
                2,
                0,
                "DADA",
                "AY2021",
                10000381,
                "ORG0003767",
                "ESFA-19807",
                new DateTime(2020, 08, 01),
                new DateTime(2021, 07, 31))
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = "DADA-1002",
                        TotalPlannedValue = 1151460.00m,
                        PlannedValueEnvelope1 = null,
                        PlannedValueEnvelope2 = null,
                        FundingStreamPeriodCode = "DADA2021",
                        ApprovedContractDeliverables = new List<ApprovedContractDeliverable>()
                    }
                }
            };

            // act
            ApprovedContractInfo transformedContractDto = approvedContract.ToApprovedContractInfo();

            // assert
        }
    }
}
