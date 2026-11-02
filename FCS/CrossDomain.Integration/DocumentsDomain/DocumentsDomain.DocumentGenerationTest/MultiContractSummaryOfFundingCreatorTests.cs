namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner.DocumentConfiguration;
    using Integration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using SFA.FCT.DocumentsDomain.DataStore.Repositories;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories;

    [TestClass]
    public class MultiContractSummaryOfFundingCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MultiContractSummaryOfFundingCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIs19TRN2020()
        {
            // arrange
            var creator = new MultiContractSummaryOfFundingCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPayCalcPolicyQueryRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IContractReferenceConfigRepository>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = false,
                IsAmendment = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "19TRN2020"
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }
    }
}