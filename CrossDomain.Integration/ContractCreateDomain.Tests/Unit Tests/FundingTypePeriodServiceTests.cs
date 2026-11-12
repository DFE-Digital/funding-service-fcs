namespace ContractCreateDomain.Tests.Unit_Tests
{
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FundingTypePeriodServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypePeriodService_ShouldEnrichContract()
        {
            // Arrange
            var repositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var fundingTypePeriod = new FundingTypeFundingPeriod
            {
                FundingTypeCode = "FTC",
                FundingPeriodName = "FP",
                SkipCaseloadAssignment = true,
                SkipReviewAndInternalApproval = true,
                SkipDocumentMerge = true
            };
            repositoryMock.Setup(x => x.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(fundingTypePeriod).Verifiable();
            ExtendedContractType contract = new ExtendedContractType
            {
                contracts = new System.Collections.Generic.List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "AB"
                        },
                        period = new Period
                        {
                            period1 = "1516",
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCodeType.AY
                            }
                        }
                    }
                }
            };

            // Act
            FundingTypePeriodService service = new FundingTypePeriodService(repositoryMock.Object, Mock.Of<ILogger>());

            service.EnrichContract(contract);

            // Assert
            var firstContract = contract.contracts.First();
            Assert.IsNotNull(firstContract.SkipCaseloadAssignment, "SkipCaseloadAssignment was not retrieved correctly");
            Assert.IsNotNull(firstContract.SkipReviewAndInternalApproval, "SkipReviewAndInternalApproval was not retrieved correctly");
            Assert.IsNotNull(firstContract.SkipDocumentMerge, "SkipDocumentMerge was not retrieved correctly");
            Assert.IsTrue(firstContract.SkipCaseloadAssignment.Value, "SkipCaseloadAssignment was not retrieved correctly");
            Assert.IsTrue(firstContract.SkipReviewAndInternalApproval.Value, "SkipReviewAndInternalApproval was not retrieved correctly");
            Assert.IsTrue(firstContract.SkipDocumentMerge, "SkipDocumentMerge was not retrieved correctly");
        }
    }
}
