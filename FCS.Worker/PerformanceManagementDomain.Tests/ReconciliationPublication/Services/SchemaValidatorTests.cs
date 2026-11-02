namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Extensions;
    using PerformanceManagementDomain.ReconciliationPublication.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;

    [TestClass]
    public class SchemaValidatorTests
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0.FundingClaimReconciliation.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:FCReconciliation";
        private readonly DateTime _allocationStartDate = DateTime.MinValue;
        private readonly DateTime _allocationEndDate = DateTime.MaxValue;

        [TestMethod, TestCategory("UnitTest")]
        public void SchemaValidator_ShouldValidateConformingXmlAsValid()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliationDto = CreateFundingClaimReconciliation();
            fundingClaimReconciliationDto.Period.PeriodYear = "1516";
            fundingClaimReconciliationDto.ContractAllocations.ToList().ForEach(ca => ca.ContractAllocationNumber = "CAN");

            FCReconciliation corpSchemaFcr = FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliationDto);

            string xml = corpSchemaFcr.SerializeToXml();
            // act
            bool isValid = SchemaValidator.IsValid(assemblyName: AssemblyName, schemaResource: EmbeddedResourceName,
                schemaNameSpace: SchemaNamespace, xmlToValidate: xml);

            // assert
            Assert.IsTrue(isValid);
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
                        ContractAllocationNumber = "ContractAllocationNumber1",
                        AllocationStartDate = _allocationStartDate,
                        AllocationEndDate = _allocationEndDate,
                        Amounts = new AmountSummary
                        {
                            CappedClaimedValue = -1,
                            ClaimedValue = -10,
                            PlannedValue = -100,
                            ProposedReconciliationValue = -1000,
                            ReconciliationValue = -10000
                        },
                        Contract = CreateContract(),
                        ContractDeliverables = CreateContractDeliverables(),
                        FundingstreamPeriodCode = "MAIN"
                    },
                    new ContractAllocation
                    {
                        ContractAllocationNumber = "ContractAllocationNumber2",
                        AllocationStartDate = _allocationStartDate,
                        AllocationEndDate = _allocationEndDate,
                        Amounts = new AmountSummary
                        {
                            CappedClaimedValue = -2,
                            ClaimedValue = -20,
                            PlannedValue = -200,
                            ProposedReconciliationValue = -2000,
                            ReconciliationValue = -20000
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
                    ReconciliationValue = 30000
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