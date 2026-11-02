namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class AllocationSelectionFilterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_ShouldRunEdskFilterAndReturnTrueWhenFundingTypeIsEDSKFundingPeriodIsAY1920AndHasBeenAddOrUpdatedIsTrue()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);

            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, true));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "EDSK", fundingPeriod: "AY1920",
                    intent: SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.ContractIntent.NotSet,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = true
            });

            Assert.IsTrue(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_ShouldRunEdskFilterAndReturnFalseWhenFundingTypeIsEDSKFundingPeriodIsAY1920AndHasBeenAddOrUpdatedIsFalse()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, true));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "EDSK", fundingPeriod: "AY1920",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.NotSet,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = false
            });

            Assert.IsFalse(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_ShouldRunDefaultFilterAndReturnTrueWhenFundingTypeIsNotEDSKFundingPeriodIsNotAY1920AndHasBeenAddOrUpdatedIsFalse()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, false));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "OTHER", fundingPeriod: "OTHER",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.NotSet,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = false
            });

            Assert.IsTrue(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_ShouldRunDefaultFilterAndReturnTrueWhenFundingTypeIsNotEDSKFundingPeriodIsNotAY1920AndHasBeenAddOrUpdatedIsTrue()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, false));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "OTHER", fundingPeriod: "OTHER",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.NotSet,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = true
            });

            Assert.IsTrue(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_GetContractAllocationFilter_ShouldIncludeAllocationWhenIsNewSetToTrue()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, true));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "EDSK", fundingPeriod: "AY1920",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.IsNewRevisedNewOrUpdateDraft,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = false
            });

            Assert.IsTrue(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_GetContractAllocationFilter_ShouldIncludeAllocationWhenAllocationHasChangedAndIsAmendment()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, true));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "EDSK", fundingPeriod: "AY1920",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.IsAmendment,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = true
            });

            Assert.IsTrue(filterResult, "Incorrect response from GetContractAllocationFilter");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationSelectionFilter_GetContractAllocationFilter_ShouldNotIncludeAllocationWhenAllocationHasNotChangedAndIsAmendment()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, true));

            // act
            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: "EDSK", 
                    fundingPeriod: "AY1920",
                    intent: DocumentDefiner.DocumentPartCreators.ContractIntent.IsAmendment,
                    documentConfigurationSource: documentConfigurationSourceMock.Object);

            // assert
            bool filterResult = filter(new contractAllocationsContractAllocation
            {
                HasBeenAddedOrUpdated = false
            });

            Assert.IsFalse(filterResult, "Incorrect response from GetContractAllocationFilter");
        }
    }
}