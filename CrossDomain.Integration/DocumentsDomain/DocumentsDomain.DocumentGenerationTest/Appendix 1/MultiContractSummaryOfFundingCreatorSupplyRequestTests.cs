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
    public class MultiContractSummaryOfFundingCreatorSupplyRequestTests
    {
        private const string Fsp = "AEB-TEST1";
        private const string SectorBasedWorkAcademyFsp = "AEB-AS2021";

        private Mock<IContractReferenceConfigRepository> _contractReferenceConfigRepositoryMock;

        private MultiContractSummaryOfFundingCreator CreateCreator(params string[] fspCodes)
        {
            var documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.ShouldDisplayDeliverableOnSummaryOfFunding(
                    It.IsAny<contractAllocationsContractAllocation>(),
                    It.IsAny<contractDeliverablesTypeContractDeliverable>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetDeliverableNameForSummaryOfFunding(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<int>()))
                .Returns("Sub item");

            var payCalcMock = new Mock<IPayCalcPolicyQueryRepository>();
            foreach (var code in fspCodes)
            {
                var fsp = code;
                payCalcMock
                    .Setup(m => m.GetFundingStreamPeriodDeliverablesNonConnectionInfo(fsp))
                    .Returns(new List<PolicyDeliverable>
                    {
                        new PolicyDeliverable { FundingStreamPeriod = fsp, DeliverableCode = 1, ParentDeliverableCode = null }
                    });
            }

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

            return new MultiContractSummaryOfFundingCreator(
                Mock.Of<ITemplateRepository>(),
                documentConfigurationSourceMock.Object,
                fundingTypeFundingPeriodMock.Object,
                payCalcMock.Object,
                fspRepositoryMock.Object,
                _contractReferenceConfigRepositoryMock.Object);
        }

        private static contract CreateContract(string fundingTypeCode, string periodCode, string fspCode)
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
                DeliveryOrganisationDetail = new contractor { ukprn = 1, legalName = "CONTRACTING ORG" }
            };
            allocation.contractDeliverables.Add(deliverable);

            return new contract
            {
                startDate = new DateTime(2021, 8, 1),
                period = new period { period1 = periodCode },
                fundingType = new fundingType { fundingTypeCode = fundingTypeCode },
                contractor = new contractor { ukprn = 1, legalName = "CONTRACTING ORG" },
                SharedMasterApprovedContracts = new List<ApprovedContractInfo>(),
                contractAllocations = new List<contractAllocationsContractAllocation> { allocation }
            };
        }

        private static string Field(RowType row, string name)
        {
            return row.MergeFields.Single(mf => mf.Name == name).Value;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SingleContract_ReturnsSummaryRowsAndTotals()
        {
            var creator = CreateCreator(Fsp);

            var requests = creator.SupplyDocumentGenerationRequest(
                "MASTER-1", CreateContract("AEB", "2122", Fsp), "CONTAINER");

            Assert.AreEqual(1, requests.Count);
            Assert.AreEqual("1000", requests.Keys.Single());

            var request = requests.Values.Single();
            Assert.AreEqual("CONTAINER", request.TemplateContainer);

            var fields = request.MergeData.MergeFields;
            Assert.AreEqual("CONTRACTING ORG", fields.Single(f => f.Name == "OrgName").Value);
            Assert.AreEqual("1", fields.Single(f => f.Name == "Ukprn").Value);
            Assert.AreEqual("MASTER-1", fields.Single(f => f.Name == "MasterContractRef").Value);
            Assert.AreEqual("£150", fields.Single(f => f.Name == "ContractTotal").Value);
            Assert.AreEqual("£150", fields.Single(f => f.Name == "MasterContractTotal").Value);
            Assert.AreEqual("Y", fields.Single(f => f.Name == "ShowMasterContractTotal").Value);
            Assert.AreEqual("1 August 2021 to 31 July 2022", fields.Single(f => f.Name == "FundingPeriod").Value);
            Assert.AreEqual("Aug 21 - Mar 22", fields.Single(f => f.Name == "FinancialEnvelope1").Value);
            Assert.AreEqual("Apr 22 - Jul 22", fields.Single(f => f.Name == "FinancialEnvelope2").Value);

            var rows = request.MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            Assert.AreEqual(2, rows.Count);

            Assert.AreEqual("Display " + Fsp, Field(rows[0], "Column1"));
            Assert.AreEqual("ALLOC-1", Field(rows[0], "Column2"));
            Assert.AreEqual("£100", Field(rows[0], "Column3"));
            Assert.AreEqual("£50", Field(rows[0], "Column4"));
            Assert.AreEqual("£150", Field(rows[0], "Column5"));

            Assert.IsTrue(Field(rows[1], "Column1").Contains("Sub item"));
            Assert.AreEqual("£100", Field(rows[1], "Column3"));
            Assert.AreEqual("£50", Field(rows[1], "Column4"));
            Assert.AreEqual("£150", Field(rows[1], "Column5"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_Traineeships2021_UsesFebruaryToJulyFinancialPeriod()
        {
            var creator = CreateCreator(Fsp);

            var requests = creator.SupplyDocumentGenerationRequest(
                "MASTER-1", CreateContract("19TRN2020", "2021", Fsp), "CONTAINER");

            var fields = requests.Values.Single().MergeData.MergeFields;
            Assert.AreEqual("1 February 2021 to 31 July 2021", fields.Single(f => f.Name == "FundingPeriod").Value);
            Assert.AreEqual("Feb 21 - Mar 21", fields.Single(f => f.Name == "FinancialEnvelope1").Value);
            Assert.AreEqual("Apr 21 - Jul 21", fields.Single(f => f.Name == "FinancialEnvelope2").Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SectorBasedWorkAcademyAllocation_AddsRowFromReferenceConfig()
        {
            var creator = CreateCreator(SectorBasedWorkAcademyFsp);
            _contractReferenceConfigRepositoryMock
                .Setup(m => m.GetContractReferenceConfig(1, SectorBasedWorkAcademyFsp))
                .Returns(Option.Some(new ContractReferenceConfig(1, SectorBasedWorkAcademyFsp, 1000m, 500m)));

            var requests = creator.SupplyDocumentGenerationRequest(
                "MASTER-1", CreateContract("AEB", "2122", SectorBasedWorkAcademyFsp), "CONTAINER");

            var rows = requests.Values.Single().MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            Assert.AreEqual(3, rows.Count);

            var sectorRow = rows[2];
            Assert.IsTrue(Field(sectorRow, "Column1").Contains("of which Sector-based Work Academies"));
            Assert.AreEqual("£1,000", Field(sectorRow, "Column3"));
            Assert.AreEqual("£500", Field(sectorRow, "Column4"));
            Assert.AreEqual("£1,500", Field(sectorRow, "Column5"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_SectorBasedWorkAcademyWithoutReferenceConfig_AddsZeroValueRow()
        {
            var creator = CreateCreator(SectorBasedWorkAcademyFsp);

            var requests = creator.SupplyDocumentGenerationRequest(
                "MASTER-1", CreateContract("AEB", "2122", SectorBasedWorkAcademyFsp), "CONTAINER");

            var rows = requests.Values.Single().MergeData.RepeatingSections.Single(s => s.Name == "MainTable").Rows;
            var sectorRow = rows.Last();
            Assert.AreEqual("£0", Field(sectorRow, "Column3"));
            Assert.AreEqual("£0", Field(sectorRow, "Column4"));
            Assert.AreEqual("£0", Field(sectorRow, "Column5"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SupplyDocumentGenerationRequest_WithSharedMasterContract_ReturnsOneRequestPerContractOrderedByStartDate()
        {
            var creator = CreateCreator(Fsp);
            var contract = CreateContract("AEB", "2122", Fsp);
            contract.SharedMasterApprovedContracts = new List<ApprovedContractInfo>
            {
                new ApprovedContractInfo
                {
                    StartDate = new DateTime(2020, 8, 1),
                    FundingPeriod = "AY2021",
                    Allocations = new List<ApprovedContractAllocationInfo>
                    {
                        new ApprovedContractAllocationInfo
                        {
                            FundingStreamPeriodCode = Fsp,
                            ContractAllocationNumber = "SHARED-1",
                            PlannedValueEnvelope1 = 300m,
                            PlannedValueEnvelope2 = 200m,
                            TotalPlannedValue = 500m
                        }
                    }
                }
            };

            var requests = creator.SupplyDocumentGenerationRequest("MASTER-1", contract, "CONTAINER");

            Assert.AreEqual(2, requests.Count);
            Assert.AreEqual("N", requests["1000"].MergeData.MergeFields.Single(f => f.Name == "ShowMasterContractTotal").Value);
            Assert.AreEqual("Y", requests["1001"].MergeData.MergeFields.Single(f => f.Name == "ShowMasterContractTotal").Value);
            Assert.AreEqual("£650", requests["1001"].MergeData.MergeFields.Single(f => f.Name == "MasterContractTotal").Value);
            Assert.AreEqual("£500", requests["1000"].MergeData.MergeFields.Single(f => f.Name == "ContractTotal").Value);
            Assert.AreEqual("£150", requests["1001"].MergeData.MergeFields.Single(f => f.Name == "ContractTotal").Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RequiredHeaderDocumentName_Throws()
        {
            var creator = CreateCreator();
            var thrown = false;

            try
            {
                var name = creator.RequiredHeaderDocumentName;
            }
            catch (InvalidOperationException)
            {
                thrown = true;
            }

            Assert.IsTrue(thrown);
            Assert.IsFalse(creator.IsHeaderDocumentRequired);
        }
    }
}
