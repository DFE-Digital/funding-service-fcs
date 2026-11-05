namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Extensions
{
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore.Models;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class ContractAllocationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FspDeliverableExtensions_ShouldMapDeliverableConfiguration()
        {
            var deliverable = new FSPDeliverable(
                deliverableCode: 12,
                fundingStreamPeriodCode: "FSP1",
                allowProfile: true,
                displayOnFundingAgreement: true,
                mandatoryOnFundingAgreement: false,
                displayOrderOnFundingAgreement: 4,
                allowCustomDescription: true,
                shouldDisplayValue: false,
                shouldDisplayVolumeAndUnitCost: true,
                displayNameOnSummaryOfFunding: "Summary",
                displayNameOnFundingAgreement: "Funding agreement",
                displayOnSummaryOfFunding: true);

            DeliverableConfiguration configuration = deliverable.ToDeliverableConfiguration();

            Assert.AreEqual(12, configuration.DeliverableCode);
            Assert.IsTrue(configuration.IncludeOnFundingAgreement);
            Assert.IsFalse(configuration.IsMandatoryOnFundingAgreement);
            Assert.AreEqual(4, configuration.DisplayOrder);
            Assert.IsTrue(configuration.AllowCustomDescription);
            Assert.AreEqual("Funding agreement", configuration.DisplayName);
            CollectionAssert.AreEqual(new[] { 12 }, configuration.DisplayValueIsAggregate);
            Assert.IsTrue(configuration.ShouldDisplayUnitCost);
            Assert.IsTrue(configuration.ShouldDisplayVolume);
            Assert.IsFalse(configuration.ShouldDisplayValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FspDeliverableExtensions_ShouldCreateAggregateConfigurationFromProfileDeliverables()
        {
            var deliverables = new[]
            {
                new FSPDeliverable(3, "FSP1", true, true, true, 2, true, true, true, "Summary 3", "Deliverable 3", true),
                new FSPDeliverable(8, "FSP1", true, true, true, 7, true, true, true, "Summary 8", "Deliverable 8", true)
            };

            DeliverableConfiguration configuration = deliverables.ToAggregateDeliverableConfiguration();

            Assert.AreEqual(0, configuration.DeliverableCode);
            Assert.IsTrue(configuration.IncludeOnFundingAgreement);
            Assert.IsTrue(configuration.IsMandatoryOnFundingAgreement);
            Assert.AreEqual(8, configuration.DisplayOrder);
            Assert.IsFalse(configuration.AllowCustomDescription);
            Assert.AreEqual("^bTotal Funding¶", configuration.DisplayName);
            CollectionAssert.AreEqual(new[] { 3, 8 }, configuration.DisplayValueIsAggregate);
            Assert.IsFalse(configuration.ShouldDisplayUnitCost);
            Assert.IsFalse(configuration.ShouldDisplayVolume);
            Assert.IsTrue(configuration.ShouldDisplayValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetAllocationValue()
        {
            // arrange
            contractAllocationsContractAllocation contractAllocation = new contractAllocationsContractAllocation
            {
                maximumContractValue = 10
            };

            // act
            string allocationValue = contractAllocation.GetAllocationValue();
            
            // assert
            Assert.AreEqual("10", allocationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetAllocationValueOfZeroIfAllocationIsNotPresent()
        {
            // arrange
            contractAllocationsContractAllocation contractAllocation = null;

            // act
            string allocationValue = contractAllocation.GetAllocationValue();

            // assert
            Assert.AreEqual("0", allocationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetGetMay17Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[2];

            // act
            string plannedValue = contractAllocation.GetMay17Value();

            // assert
            Assert.AreEqual("544.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetGetOct17Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[2];

            // act
            string plannedValue = contractAllocation.GetOct17Value();

            // assert
            Assert.AreEqual("17.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetGetMar18Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[2];

            // act
            string plannedValue = contractAllocation.GetMar18Value();

            // assert
            Assert.AreEqual("221.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetJul17Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[3];

            // act
            string plannedValue = contractAllocation.GetJul17Value();

            // assert
            Assert.AreEqual("4845.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_GetJul17Value_ShouldReturnZeroWhenCdpsDoNotContainPeriod()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();
            

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[3];

            contractDeliverablesTypeContractDeliverable contractDeliverable = contractAllocation.contractDeliverables.Single(d => d.deliverable.deliverableCode == 1);

            contractDeliverable.contractDeliverablePeriods.Clear();

            // act
            string plannedValue = contractAllocation.GetJul17Value();

            // assert
            Assert.AreEqual("0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetJan18Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[3];

            // act
            string plannedValue = contractAllocation.GetJan18Value();

            // assert
            Assert.AreEqual("1428.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetFeb18Value()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[3];

            // act
            string plannedValue = contractAllocation.GetFeb18Value();

            // assert
            Assert.AreEqual("2992.0", plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationExtensions_ShouldGetDeliverablePeriodPlannedValue()
        {
            // arrange
            DocumentGenerationCommand documentGenerationCommand = GetNcsDocumentGenerationCommand();

            contractAllocationsContractAllocation contractAllocation =
                documentGenerationCommand.CorporateContract.contractAllocations[3];

            // act
            string plannedValue = contractAllocation.GetDeliverablePeriodPlannedValue(deliverableCode: 1, year: 2017, period: 8);

            // assert
            Assert.AreEqual("4590.0", plannedValue);
        }

        private DocumentGenerationCommand GetNcsDocumentGenerationCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentGenerationCommandNCS_FY1718.json"))
            {
                return
                    (DocumentGenerationCommand)
                        new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentGenerationCommand));
            }
        }
    }
}
