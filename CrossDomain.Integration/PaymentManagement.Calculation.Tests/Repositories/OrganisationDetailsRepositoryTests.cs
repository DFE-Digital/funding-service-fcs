namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    [TestClass]
    public class OrganisationDetailsRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationDetailsRepository_ShouldReturnOrganisationDetails()
        {
            const string allocationNumber = "TEST-1234";
            const int versionNumber = 3;
            const string organisationId = "ORG000123";
            const int ukprn = 12345678; 

            // arrange
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers
                    .Where(o => o.AllocationNumber == allocationNumber)
                    .ToList()
                    .ForEach(e => context.OrganisationIdentifiers.Remove(e));

                context.OrganisationIdentifiers.Add(new OrganisationIdentifer
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = versionNumber,
                    MainOrganisationIdentifier = organisationId,
                    OrganisationId = ukprn.ToString() // strangely this is the UKPRN
                });

                context.SaveChanges();
            }

            OrganisationDetailsRepository repository = new OrganisationDetailsRepository();

            // act
            OrganisationDetails organisationDetails = repository.GetOrganisationDetailsForAllocation(allocationNumber, versionNumber,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            organisationDetails.Should().NotBeNull("a non-null DTO should be returned");
            organisationDetails.OrganisationId.Should().Be(organisationId, "stored OrganisationId should be returned");
            organisationDetails.Ukprn.Should().Be(ukprn, "stored UKPRN should be returned");
        }
    }
}
