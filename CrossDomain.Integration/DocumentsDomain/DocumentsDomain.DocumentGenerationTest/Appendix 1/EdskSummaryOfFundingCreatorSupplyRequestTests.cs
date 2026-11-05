namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories;
    using SFA.FCT.DocumentsDomain.Integration;
    using ContractReferenceConfig = DataStore.Models.ContractReferenceConfig;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class EdskSummaryOfFundingCreatorSupplyRequestTests
    {
        private const string Fsp = "EDSK-TEST1";
        private const string SectorBasedWorkAcademyFsp = "AEBC-ASCL2021";

        private Mock<IContractReferenceConfigRepository> _contractReferenceConfigRepositoryMock;

        private EdskSummaryOfFundingDocumentPartCreator CreateCreator(string fspCode)
        {
            var documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.GetAllocationName(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns("Stream name");
            documentConfigurationSourceMock
                .Setup(m => m.ShouldDisplayDeliverableOnSummaryOfFunding(
                    It.IsAny<contractAllocationsContractAllocation>(),
                    It.IsAny<contractDeliverablesTypeContractDeliverable>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetDeliverableNameForSummaryOfFunding(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<int>()))
                .Returns("Sub item");

            var payCalcMock = new Mock<IPayCalcPolicyQueryRepository>();
            payCalcMock
                .Setup(m => m.GetFundingStreamPeriodDeliverablesNonConnectionInfo(fspCode))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable { FundingStreamPeriod = fspCode, DeliverableCode = 1, ParentDeliverableCode = null }
                });

            var fundingTypeFundingPeriodMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractManagement.DataStore.Model.FundingTypeFundingPeriod());

            var fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock
                .Setup(r => r.GetByKey(It.IsAny<string>()))
                .Returns((string code) => new FundingStreamPeriod(code, "Display " + code, 1, false, false, "", "", "", ""));

            _contractReferenceConfigRepositoryMock = new Mock<IContractReferenceConfigRepository>();
            _contractReferenceConfigRepositoryMock
                .Setup(m => m.GetContractReferenceConfig(It.IsAny<int>(), It.IsAny<string>()))
                .Returns(Option.None<ContractReferenceConfig>());

            return new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                documentConfigurationSourceMock.Object,
                fundingTypeFundingPeriodMock.Object,
                payCalcMock.Object,
                fspRepositoryMock.Object,
                _contractReferenceConfigRepositoryMock.Object);
        }

        private static contract CreateContract(string fspCode, int allocationUkprn)
        {
            var deliverable = new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType { deliverableCode = 1 }
            };
            deliverable.contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                year = 2021,
                period = 8,
                plannedValue = 100
            });
            deliverable.contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                year = 2022,
                period = 5,
                plannedValue = 50
            });

            var allocation = new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "ALLOC-1",
                fundingStreamPeriodCode = fspCode,
                DeliveryOrganisation = "DO-1",
                DeliveryOrganisationDetail = new contractor { ukprn = allocationUkprn, legalName = "DELIVERY ORG" }
            };
            allocation.contractDeliverables.Add(deliverable);

            return new contract
            {
                startDate = new DateTime(2021, 8, 1),
                period = new period { period1 = "2122" },
                fundingType = new fundingType { fundingTypeCode = "EDSK" },
                contractor = new contractor { ukprn = 1, legalName = "CONTRACTING ORG" },
                contractAllocations = new List<contractAllocationsContractAllocation> { allocation }
            };
        }

        private static string Field(RowType row, string name)
        {
            return row.MergeFields.Single(mf => mf.Name == name).Value;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SingleAllocationDeliveredByContractingOrg_ReturnsAllocationAndDeliverableRows()
        {
            var creator = CreateCreator(Fsp);

            var requests = creator.SupplyDocumentGenerationRequest("MASTER-1", CreateContract(Fsp, 1), "CONTAINER");

            var request = requests.Single().Value;
            Assert.AreEqual("1000", requests.Keys.Single());
            Assert.AreEqual("£150", request.MergeData.MergeFields.Single(f => f.Name == "ContractTotal").Value);
            Assert.AreEqual("CONTRACTING ORG", request.MergeData.MergeFields.Single(f => f.Name == "ContractingOrgName").Value);
            Assert.IsNotNull(request.MutateGeneratedDocument);

            var rows = request.MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            Assert.AreEqual(2, rows.Count);

            Assert.AreEqual("Stream name", Field(rows[0], "FundingStreamName"));
            Assert.AreEqual(string.Empty, Field(rows[0], "OrgName"));
            Assert.AreEqual("ALLOC-1", Field(rows[0], "AllocationRef"));
            Assert.AreEqual("£100", Field(rows[0], "AllocationPeriodOneTotal"));
            Assert.AreEqual("£50", Field(rows[0], "AllocationPeriodTwoTotal"));
            Assert.AreEqual("£150", Field(rows[0], "AllocationTotal"));

            Assert.IsTrue(Field(rows[1], "OrgName").Contains("Sub item"));
            Assert.AreEqual("£100", Field(rows[1], "AllocationPeriodOneTotal"));
            Assert.AreEqual("£50", Field(rows[1], "AllocationPeriodTwoTotal"));
            Assert.AreEqual("£150", Field(rows[1], "AllocationTotal"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SingleAllocationDeliveredByOtherOrg_AddsFundingStreamHeadingRow()
        {
            var creator = CreateCreator(Fsp);

            var requests = creator.SupplyDocumentGenerationRequest("MASTER-1", CreateContract(Fsp, 2), "CONTAINER");

            var rows = requests.Single().Value.MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            Assert.AreEqual(3, rows.Count);
            Assert.AreEqual("Stream name", Field(rows[0], "FundingStreamName"));
            Assert.AreEqual("DELIVERY ORG", Field(rows[1], "OrgName"));
            Assert.AreEqual(string.Empty, Field(rows[1], "FundingStreamName"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SectorBasedWorkAcademyWithReferenceConfig_AddsRowWithEnvelopeValues()
        {
            var creator = CreateCreator(SectorBasedWorkAcademyFsp);
            _contractReferenceConfigRepositoryMock
                .Setup(m => m.GetContractReferenceConfig(2, SectorBasedWorkAcademyFsp))
                .Returns(Option.Some(new ContractReferenceConfig(2, SectorBasedWorkAcademyFsp, 1000m, 500m)));

            var requests = creator.SupplyDocumentGenerationRequest("MASTER-1", CreateContract(SectorBasedWorkAcademyFsp, 2), "CONTAINER");

            var rows = requests.Single().Value.MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            var sectorRow = rows.Last();
            Assert.IsTrue(Field(sectorRow, "OrgName").Contains("of which Sector-based Work Academies"));
            Assert.AreEqual("£1,000", Field(sectorRow, "AllocationPeriodOneTotal"));
            Assert.AreEqual("£500", Field(sectorRow, "AllocationPeriodTwoTotal"));
            Assert.AreEqual("£1,500", Field(sectorRow, "AllocationTotal"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SectorBasedWorkAcademyWithoutReferenceConfig_AddsZeroValueRow()
        {
            var creator = CreateCreator(SectorBasedWorkAcademyFsp);

            var requests = creator.SupplyDocumentGenerationRequest("MASTER-1", CreateContract(SectorBasedWorkAcademyFsp, 2), "CONTAINER");

            var sectorRow = requests.Single().Value.MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows.Last();
            Assert.AreEqual("£0", Field(sectorRow, "AllocationTotal"));
        }
    }
}
