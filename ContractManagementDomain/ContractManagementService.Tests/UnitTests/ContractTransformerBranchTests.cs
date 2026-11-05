namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractTransformerBranchTests
    {
        private static CorporateContract.contract Build(string fundingTypeCode, Action<CorporateContract.contractType, CorporateContract.contractAllocationsContractAllocation> customise = null)
        {
            var allocation = new CorporateContract.contractAllocationsContractAllocation
            {
                contractAllocationNumber = "A1",
                startDate = DateTime.Today,
                endDate = DateTime.Today,
                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>()
            };

            var child = new CorporateContract.contractType
            {
                contractNumber = "C1",
                fundingType = new CorporateContract.fundingType { fundingTypeCode = fundingTypeCode },
                contractStatus = new CorporateContract.contractStatusType { status = "Internally - Approved", parentStatus = "Approved" },
                contractAllocations = new List<CorporateContract.contractAllocationsContractAllocation> { allocation }
            };

            customise?.Invoke(child, allocation);

            return new CorporateContract.contract
            {
                contractNumber = "M1",
                fundingType = new CorporateContract.fundingType { fundingTypeCode = fundingTypeCode },
                contractStatus = new CorporateContract.contractStatusType { status = "Draft", parentStatus = "Draft" },
                contracts = new List<CorporateContract.contractType> { child }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_SbdFunding_DefaultsMissingProcurementValues()
        {
            var result = new ContractTransformer().TransformToCorporateSchemaContract(Build("SBD"));

            var attrs = result.contracts[0].contractAllocations[0].ProcurementAttrs;
            Assert.AreEqual("XX", attrs.TenderSpecReference);
            Assert.AreEqual("xxxxxxxxxxx", attrs.AgreementNumber);
            Assert.AreEqual("XX", attrs.RegionType);
            Assert.AreEqual("XX", attrs.LEPName);
            Assert.AreEqual("XX", attrs.LEPCode);
            Assert.AreEqual("XX", attrs.InvestmentPriority);
            Assert.AreEqual("XX", attrs.ActivityDescription);
            Assert.AreEqual("XX", attrs.AwardReference);
            Assert.AreEqual("XX", attrs.TenderSpecTitle);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_SbdFunding_KeepsSuppliedProcurementValues()
        {
            var contract = Build("SBD", (c, a) =>
            {
                a.tenderSpecificationReference = "TSR";
                a.AgreementNumber = "12345678901";
            });

            var attrs = new ContractTransformer().TransformToCorporateSchemaContract(contract).contracts[0].contractAllocations[0].ProcurementAttrs;

            Assert.AreEqual("TSR", attrs.TenderSpecReference);
            Assert.AreEqual("12345678901", attrs.AgreementNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_NonSbdFunding_DoesNotDefaultProcurementValues()
        {
            var attrs = new ContractTransformer().TransformToCorporateSchemaContract(Build("AAA")).contracts[0].contractAllocations[0].ProcurementAttrs;

            Assert.IsNull(attrs.TenderSpecReference);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_MapsChildStatusRemovingSpacesAndHyphens()
        {
            var result = new ContractTransformer().TransformToCorporateSchemaContract(Build("AAA"));

            Assert.AreEqual(CorporateSchema.contractStatusTypeStatus.InternallyApproved, result.contracts[0].contractStatus.status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_Termination_PopulatesTerminationAttrs()
        {
            var termination = new DateTime(2022, 3, 4);
            var contract = Build("AAA", (c, a) =>
            {
                c.TerminationDate = termination;
                c.TerminationReason = "NoticefromProvider";
                a.StopNewStartsDate = new DateTime(2022, 1, 1);
                a.NewStartsSuspendedReason = "reason";
                a.FundingCessationDate = new DateTime(2022, 2, 2);
            });

            var child = new ContractTransformer().TransformToCorporateSchemaContract(contract).contracts[0];

            Assert.AreEqual(termination, child.TerminationContractAttrs.terminationDate);
            Assert.AreEqual(CorporateSchema.ReasonForTerminationType.NoticefromProvider, child.TerminationContractAttrs.ReasonForTermination);
            var alloc = child.contractAllocations[0].allocationTerminationAttrs;
            Assert.AreEqual(new DateTime(2022, 1, 1), alloc.stopNewStartsFromDate);
            Assert.AreEqual("reason", alloc.newStartsSuspendedReason);
            Assert.AreEqual(new DateTime(2022, 2, 2), alloc.fundingCessationDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_DeliveryOrganisation_MapsRelationship()
        {
            var contract = Build("AAA", (c, a) =>
            {
                a.DeliveryOrganisation = "ORG1";
                a.DeliveryOrganisationDetail = new CorporateContract.contractor { organisationIdentifier = "ORG1", legalName = "Org One", ukprn = 123 };
            });

            var relationship = new ContractTransformer().TransformToCorporateSchemaContract(contract).contracts[0].contractAllocations[0].allocationOrganisationRelationships;

            Assert.AreEqual("A1", relationship.contractAllocationNumber);
            Assert.AreEqual(CorporateSchema.allocationOrganisationRelationshipType.DELIVERYORGANISATION, relationship.RelationshipType);
            Assert.AreEqual("ORG1", relationship.Organisation.organisationIdentifier);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_NoDeliveryOrganisation_NoRelationship()
        {
            var relationship = new ContractTransformer().TransformToCorporateSchemaContract(Build("AAA")).contracts[0].contractAllocations[0].allocationOrganisationRelationships;

            Assert.IsNull(relationship);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Transform_LearningRatePremium_ParsedOrDefaultsToOne()
        {
            var withValue = Build("AAA", (c, a) => a.LearningRatePremium = "1.25");
            var without = Build("AAA");
            var transformer = new ContractTransformer();

            Assert.AreEqual(1.25m, transformer.TransformToCorporateSchemaContract(withValue).contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium);
            Assert.AreEqual(1m, transformer.TransformToCorporateSchemaContract(without).contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium);
        }
    }
}
