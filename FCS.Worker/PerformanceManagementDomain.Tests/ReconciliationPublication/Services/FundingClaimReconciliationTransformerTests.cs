namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Services
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Extensions;
    using PerformanceManagementDomain.ReconciliationPublication.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;

    [TestClass]
    public class FundingClaimReconciliationTransformerTests
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0.FundingClaimReconciliation.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:FCReconciliation";
        private readonly DateTime _allocationStartDate = DateTime.MinValue;
        private readonly DateTime _allocationEndDate = DateTime.MaxValue;

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformContractorAndStatus()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr =
                FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual("LegalNameXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Contractor.ContractorNonPKeyAttrs.LegalName, "The LegalName has not been set correctly");
            Assert.AreEqual(12345678, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Contractor.ContractorNonPKeyAttrs.UKPRN, "The UKPRN has not been set correctly");
            Assert.AreEqual("OrganisationIdentifierXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Contractor.ContractorPKeyAttrs.OrganisationIdentifier, "The OrganisationIdentifier has not been set correctly");

            Assert.AreEqual(1, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.ClaimVersionNumber);
            Assert.AreEqual(ReconciliationStatusST.Published, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.Status, "The Status has not been set correctly");
            Assert.AreEqual(DateTime.MaxValue, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.StatusLastUpdatedDate, "The StatusLastUpdatedDate has not been set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformAllocationGroup()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr =
                FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual("AllocationGroupNameXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.AllocationGroup.AllocationGroupNonPKeyAttrs.AllocationGroupName, "The AllocationGroupName has been set correctly");
            Assert.AreEqual("AllocationGroupCodeXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.AllocationGroup.AllocationGroupPKeyAttrs.AllocationGroupCode, "The AllocationGroupCode has been set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformClaimType()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr =
                FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual("ClaimTypeNameXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.ClaimType.ClaimTypeNonPKeyAttrs.ClaimTypeName, "The ClaimTypeName has been set correctly");
            Assert.AreEqual("ClaimTypeCodeXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.ClaimType.ClaimTypePKeyAttrs.ClaimTypeCode, "The ClaimTypeCode has been set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformPeriod()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr =
                FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual("PeriodXX", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Period.Period, "The period has not been set correctly");
            Assert.AreEqual(PeriodTypeNameST.FINANCIALYEAR, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Period.PeriodTypeNonPKeyAttrs.PeriodTypeName, "The periodtypename has not been set correctly");
            Assert.AreEqual(PeriodTypeCodeST.FY, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationPKeyAttrs.Period.PeriodTypePKeyAttrs.PeriodTypeCode, "The periodtypecode has not been set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformAmount()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr =
                FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual(3, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.CappedClaimedValue, "The CappedClaimedValue has not been set correctly");
            Assert.AreEqual(30, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimedValue, "The ClaimedValue has not been set correctly");
            Assert.AreEqual(300, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.PlannedValue, "The PlannedValue has not been set correctly");
            Assert.AreEqual(3000, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ProposedReconciliationValue, "The ProposedReconciliationValue has not been set correctly");
            Assert.AreEqual(30000, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ReconciliationValue, "The ReconciliationValue has not been set correctly");
            Assert.AreEqual(300000, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.AdjustedCappedClaimedValue, "The AdjustedCappedClaimedValue has not been set correctly");

            Assert.IsNotNull(corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimAdjustments, "The ClaimAdjustments property was null");
            Assert.AreEqual(100, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimAdjustments.ClaimAdjustmentValue, "ClaimAdjustmentValue was null");
            Assert.AreEqual("Claim Error", corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimAdjustments.ClaimAdjustmentReason, "ClaimAdjustmentReason was null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldTransformContractAllocations()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();

            // act
            FCReconciliation corpSchemaFcr = FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            // assert
            Assert.AreEqual(1, corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.ContractAllocation.Count, "The number of allocations is not correct");

            ContractAllocationAllAttrsCT corpSchemaContractAllocation = corpSchemaFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.ContractAllocation.Single();

            Assert.AreEqual("ContractAllocationNumber", corpSchemaContractAllocation.ContractAllocationPKeyAttrs.ContractAllocationNumber, "The contract allocation numbers have not been transformed correctly");
            Assert.AreEqual(_allocationStartDate, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AllocationStartDate, "The contract allocation start date has not been transformed correctly");
            Assert.AreEqual(_allocationEndDate, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AllocationEndDate, "The contract allocation end date has not been transformed correctly");
            Assert.AreEqual("MAIN", corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.FundingstreamPeriodCode, "The contract allocation FundingstreamPeriodCode has not been transformed correctly");
            Assert.AreEqual(-1, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.CappedClaimedValue, "The CappedClaimedValue has not been correctly set");
            Assert.AreEqual(-10, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ClaimedValue, "The ClaimedValue has not been correctly set");
            Assert.AreEqual(-100, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.PlannedValue, "The PlannedValue has not been correctly set");
            Assert.AreEqual(-1000, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ProposedReconciliationValue, "The ProposedReconciliationValue has not been correctly set");
            Assert.AreEqual(-10000, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ReconciliationValue, "The ReconciliationValue has not been correctly set");
            Assert.AreEqual(-100000, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.AdjustedCappedClaimedValue, "The AdjustedCappedClaimedValue has not been correctly set");

            Assert.IsNotNull(corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ClaimAdjustments, "The ClaimAdjustments property was null");
            Assert.AreEqual(100, corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ClaimAdjustments.ClaimAdjustmentValue, "ClaimAdjustmentValue was null");
            Assert.AreEqual("Claim Error", corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.AmountAttrs.ClaimAdjustments.ClaimAdjustmentReason, "ClaimAdjustmentReason was null");

            Assert.AreEqual("ContractNumber", corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.ContractNumber, "The ContractNumber has not been set");
            Assert.AreEqual(DateTime.MaxValue, corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.ContractApprovalDate, "The ContractNumber has not been set");
            Assert.AreEqual(1, corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.ContractSubVersionNumber, "The ContractSubVersionNumber has not been set");
            Assert.AreEqual(2, corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.ContractVersionNumber, "The ContractVersionNumber has not been set");
            Assert.AreEqual("FundingTypeName", corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.FundingTypeAllAttrs.FundingTypeNonPKeyAttrs.FundingTypeName, "The FundingTypeName has not been set");
            Assert.AreEqual("FundingTypeCode", corpSchemaContractAllocation.ContractAllocationDNAttrs.ContractAttrs.FundingTypeAllAttrs.FundingPKeyAttrs.FundingTypeCode, "The FundingTypeCode has not been set");
            int d = 1;
            foreach (ContractDeliverablesAllAttrsCTContractDeliverable deliverable in corpSchemaContractAllocation.ContractAllocationNonPKeyAttrs.ContractDeliverables)
            {
                Assert.AreEqual(1 * d, deliverable.AmountAttrs.CappedClaimedValue, "The CappedClaimedValue on the deliverable has not been correctly set");
                Assert.AreEqual(10 * d, deliverable.AmountAttrs.ClaimedValue, "The ClaimedValue on the deliverable has not been correctly set");
                Assert.AreEqual(100 * d, deliverable.AmountAttrs.PlannedValue, "The PlannedValue on the deliverable has not been correctly set");
                Assert.AreEqual(1000 * d, deliverable.AmountAttrs.ProposedReconciliationValue, "The ProposedReconciliationValue on the deliverable has not been correctly set");
                Assert.AreEqual(10000 * d, deliverable.AmountAttrs.ReconciliationValue, "The ReconciliationValue on the deliverable has not been correctly set");
                Assert.AreEqual(d, deliverable.Deliverable.DeliverableCode, "The DeliverableCode on the deliverable has not been correctly set");
                Assert.AreEqual(d.ToString(), deliverable.Deliverable.DeliverableName, "The DeliverableName on the deliverable has not been correctly set");
                d++;
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationTransformer_ShouldValidateTransformedObject()
        {
            // arrange
            XmlSchemaSet schemas = new XmlSchemaSet();
            List<string> validationErrors = new List<string>();
            using (Stream stream = Assembly.LoadFrom(AssemblyName).GetManifestResourceStream(EmbeddedResourceName))
            {
                if (stream == null)
                {
                    Assert.Fail("Could not load FundingClaimReconciliation schema resource.");
                }

                schemas.Add(SchemaNamespace, new XmlTextReader(stream));
            }

            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();
            fundingClaimReconciliationDto.Period.PeriodYear = "1516";
            fundingClaimReconciliationDto.ContractAllocations.ToList().ForEach(ca => ca.ContractAllocationNumber = "CAN");

            FCReconciliation corpSchemaFcr = FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            string xml = corpSchemaFcr.SerializeToXml();

            // act
            XDocument
                .Parse(xml, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo)
                .Validate(schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));

            // assert
            Assert.IsFalse(validationErrors.Any(), $"Schema validation errors returned: {string.Join("\n", validationErrors)}");
        }

        private FundingClaimReconciliation CreateFundingClaimReconciliation()
        {
            return new FundingClaimReconciliation
            {
                Contractor = new Contractor
                {
                    LegalName = "LegalNameXX",
                    OrganisationIdentifier = "OrganisationIdentifierXX",
                    UKPRN = 12345678
                },
                AllocationGroup = new AllocationGroup
                {
                    AllocationGroupName = "AllocationGroupNameXX",
                    AllocationGroupCode = "AllocationGroupCodeXX"
                },
                ClaimType = new ClaimType
                {
                    ClaimTypeName = "ClaimTypeNameXX",
                    ClaimTypeCode = "ClaimTypeCodeXX"
                },
                Period = new Period
                {
                    PeriodTypeName = PeriodTypeName.FINANCIALYEAR,
                    PeriodTypeCode = PeriodTypeCode.FY,
                    PeriodYear = "PeriodXX"
                },
                ClaimVersionNumber = 1,
                ContractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        ContractAllocationNumber = "ContractAllocationNumber",
                        AllocationStartDate = _allocationStartDate,
                        AllocationEndDate = _allocationEndDate,
                        Amounts = new AmountSummary
                        {
                            CappedClaimedValue = -1,
                            ClaimedValue = -10,
                            PlannedValue = -100,
                            ProposedReconciliationValue = -1000,
                            ReconciliationValue = -10000,
                            AdjustedCappedClaimValue = -100000,
                            ClaimAdjustments = new ClaimAdjustment(100, "Claim Error")
                        },
                        Contract = CreateContract(),
                        ContractDeliverables = CreateContractDeliverables(),
                        FundingstreamPeriodCode = "MAIN"
                    }
                },
                Status = ReconciliationStatus.Published,
                StatusLastUpdatedDate = DateTime.MaxValue,
                Amounts = new AmountSummary
                {
                    CappedClaimedValue = 3,
                    ClaimedValue = 30,
                    PlannedValue = 300,
                    ProposedReconciliationValue = 3000,
                    ReconciliationValue = 30000,
                    AdjustedCappedClaimValue = 300000
                }
            };
        }

        private IList<ContractDeliverable> CreateContractDeliverables()
        {
            List<ContractDeliverable> deliverables = new List<ContractDeliverable>();
            for (int deliverableNumber = 1; deliverableNumber < 3; deliverableNumber++)
            {
                deliverables.Add(new ContractDeliverable
                {
                    Amounts = new AmountSummary
                    {
                        CappedClaimedValue = deliverableNumber * 1,
                        ClaimedValue = deliverableNumber * 10,
                        PlannedValue = deliverableNumber * 100,
                        ProposedReconciliationValue = deliverableNumber * 1000,
                        ReconciliationValue = deliverableNumber * 10000
                    },
                    Deliverable = new Deliverable
                    {
                        DeliverableCode = deliverableNumber,
                        DeliverableName = deliverableNumber.ToString()
                    }
                });
            }

            return deliverables;
        }

        private Contract CreateContract()
        {
            return new Contract
            {
                ContractNumber = "ContractNumber",
                ContractSubVersionNumber = 1,
                ContractVersionNumber = 2,
                ContractApprovalDate = DateTime.MaxValue,
                FundingType = new FundingType
                {
                    FundingTypeCode = "FundingTypeCode",
                    FundingTypeName = "FundingTypeName"
                }
            };
        }
    }
}
