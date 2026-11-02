namespace Datafix.Tests.Tests
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class CrmAccountRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmAccountRepository_ShouldUpdate()
        {
            const int ukprn = 10000001;
            const string newName = "test";
            // act
            CrmAccountRepository.UpdateName(10000001, newName);

            // assert
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var name = context.AccountSet.Where(a => a.sfa_UKPRN == ukprn.ToString()).Select(a => a.Name).Single();

                Assert.AreEqual(name, newName);
            }
        }
    }
}
