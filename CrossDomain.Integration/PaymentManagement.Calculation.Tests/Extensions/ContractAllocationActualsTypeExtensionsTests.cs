namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class ContractAllocationActualsTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationActualsTypeExtensions_ShouldTransform()
        {
            // arrange
            int? expectedCappingApportionmentPriorityOrder = 666;

            ContractAllocationActualsType contractAllocationActualsType = new ContractAllocationActualsType
            {
                ContractReference = new ContractReferenceType
                {
                    ContractNumber = "MAIN-1234",
                    ContractVersionNumber = 2
                },
                ContractorReference = new OrganisationReferenceType
                {
                    OrganisationIdentifier = "ORG123",
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier
                        {
                            organisationIdentifier = "ukprn1",
                            organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                FundingStreamPeriodCode = "FSP1",
                ContractAllocationNumber = "AN1",
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType
                    {
                        ActualValue = 1,
                        ActualVolume = 2,
                        DeliverableCode = 1,
                        Period = "202002"
                    }
                }
            };

            var fspDeliverableInfos = new List<FspDeliverableInfo> 
            { new FspDeliverableInfo(1, true, expectedCappingApportionmentPriorityOrder, 11, allowPayment:true) };

            var cappingGroups = new List<CappingGroup>
            {
                new CappingGroup(9000, true, false),
                new CappingGroup(9001, false, true),
                new CappingGroup(9002, false, false)
            };

            // act
            var input = contractAllocationActualsType.ToCalculationAllocationInput(fspDeliverableInfos, cappingGroups);
            
            // assert
            Assert.AreEqual(contractAllocationActualsType.ContractReference.ContractNumber, input.ContractNumber, 
                "The contract number is not right");
            Assert.AreEqual(expectedCappingApportionmentPriorityOrder, input.Deliverables[0].CappingApportionmentPriorityOrder, 
                "The CappingApportionmentPriorityOrder is not right");
            Assert.AreEqual(true, input.Deliverables[0].AllowProfile, "The AllowProfile is not right");
            Assert.AreEqual(true, input.Deliverables[0].AllowPayment, "The AllowPayment is not right");
            Assert.AreEqual(11, input.Deliverables[0].FundingStreamPeriodCappingGroupId, "The FundingStreamPeriodCappingGroupId is not right");

            cappingGroups.ForEach(cg =>
            {
                var resultCappingGroup = input.CappingGroups.Single(resultCg => resultCg.FundingStreamPeriodCappingGroupId == cg.FundingStreamPeriodCappingGroupId);
                Assert.AreEqual(cg.AllowUnderDeliveryToBeReUsed, resultCappingGroup.AllowUnderDeliveryToBeReUsed,
                    $"The AllowUnderDeliveryToBeReUsed is not correct for FundingStreamPeriodCappingGroupId {cg.FundingStreamPeriodCappingGroupId}");
                Assert.AreEqual(cg.AllowOverDeliveryToBeOffset, resultCappingGroup.AllowOverDeliveryToBeOffset,
                    $"The AllowOverDeliveryToBeOffset is not correct for FundingStreamPeriodCappingGroupId {cg.AllowOverDeliveryToBeOffset}");
            });

        }
    }
}
