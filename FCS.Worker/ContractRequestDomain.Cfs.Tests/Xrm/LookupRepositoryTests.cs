namespace ContractRequestDomain.Cfs.Tests.Xrm
{
    using System.Linq;
    using ContractRequestDomain.Cfs.Xrm.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class LookupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupRepository_ShouldGetOrgEntityReference()
        {
            // arrange
            LookupRepository lookupRepository = new LookupRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            string ukprn = GetUkprnFromCrm();

            // act
            EntityReference er = lookupRepository.GetOrgEntityReference(ukprn);

            // assert
            Assert.IsNotNull(er);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupRepository_ShouldGetFundingTypeEntityReference()
        {
            // arrange
            LookupRepository lookupRepository = new LookupRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            const string fundingTypeCode = "EOP";

            // act
            EntityReference er = lookupRepository.GetFundingTypeEntityReference(fundingTypeCode);

            // assert
            Assert.IsNotNull(er);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupRepository_ShouldGetFundingStreamPeriodEntityReference()
        {
            // arrange
            LookupRepository lookupRepository = new LookupRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            const string fundingStreamPeriodCode = "ALLF1819";

            // act
            EntityReference er = lookupRepository.GetFundingStreamPeriodEntityReference(fundingStreamPeriodCode);
            lookupRepository.GetFundingStreamPeriodEntityReference(fundingStreamPeriodCode);
            // assert
            Assert.IsNotNull(er);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupRepository_ShouldGetFundingPeriodEntityReference()
        {
            // arrange
            LookupRepository lookupRepository = new LookupRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            const string fundingPeriodName = "AY1819";

            // act
            EntityReference er = lookupRepository.GetFundingPeriodEntityReference(fundingPeriodName);
            lookupRepository.GetFundingPeriodEntityReference(fundingPeriodName);
            // assert
            Assert.IsNotNull(er);

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupRepository_ShouldGeDeliverableEntityReference()
        {
            // arrange
            LookupRepository lookupRepository = new LookupRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            const string fundingStreamPeriodCode = "ALLF1819";
            const int deliverableCode = 5;

            // act
            EntityReference er = lookupRepository.GetDeliverableEntityReference(fundingStreamPeriodCode, deliverableCode);
            lookupRepository.GetDeliverableEntityReference(fundingStreamPeriodCode, deliverableCode);
            // assert
            Assert.IsNotNull(er);
        }

        private string GetUkprnFromCrm()
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.AccountSet.First(a => a.sfa_UKPRN != null).sfa_UKPRN;
            }
        }
    }
}
