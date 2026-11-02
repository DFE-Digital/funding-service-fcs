namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System;
    using System.Linq;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class OrganisationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_GetOrganisationEntityId_ShouldOrganisationEntityIdFromCrm()
        {
            const string ukprn = "654321";

            // arrange
            DeleteOrganisation(ukprn);
            EntityReference expectedOrgEntityReference = CreateOrganisation(ukprn, ukprn, "Test Org");

            OrganisationRepository organisationRepository = new OrganisationRepository(OrganizationService);

            // act
            Guid actualOrganisationEntityId = organisationRepository.GetOrganisationEntityId(ukprn);

            // assert
            Assert.AreEqual(expectedOrgEntityReference.Id, actualOrganisationEntityId);
        }

        private static void DeleteOrganisation(string ukprnForTest)
        {
            using (XrmServiceContext context = new XrmServiceContext(OrganizationService))
            {
                context.AccountSet.Where(a => a.sfa_UKPRN == ukprnForTest).ForEach(a => OrganizationService.Delete(a.LogicalName, a.Id));
            }
        }

        private static EntityReference CreateOrganisation(string ukprn, string organisationId, string providerName)
        {
            using (XrmServiceContext context = new XrmServiceContext(OrganizationService))
            {
                Account organisation = new Account
                {
                    sfa_UKPRN = ukprn,
                    sfa_OrganisationID = organisationId,
                    Name = providerName
                };

                context.AddObject(organisation);
                context.SaveChanges();

                return organisation.ToEntityReference();
            }
        }

        private static IOrganizationService OrganizationService => CrmConnectionFactory.GetRetryOnErrorOrganizationService();
    }
}
