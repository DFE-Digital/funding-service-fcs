namespace OrganisationDomain.Integration.DataStore.Tests.Repositories
{
    using System.Data.Entity;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class OrganisationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_ShouldGetAllUkprnsForOrgsWithoutUkrlpData()
        {
            // arrange
            const int numUkprnsExpected = 5;
            const string testOrgName = "OrgRepositoryIntegrationTest";

            using (var context = new OrganisationDomainDbContext())
            {
                // cleanup
                context.Organisations.Where(o => o.TradingName == testOrgName)
                       .ForEach(o => context.Organisations.Remove(o));

                // set all orgs to have Ukrlp data
                context.Organisations.ForEach(o => o.HasUkrlpBeenCalledSuccessfully = true);

                context.SaveChanges();

                // change first 25 orgs to not have ukrlp data
                for (var i = 0; i < numUkprnsExpected; i++)
                {
                    int ukprn = i + 7600;

                    var newOrg = new Organisation
                    {
                        Ukprn = ukprn,
                        Upin = ukprn,
                        TradingName = "OrgRepositoryIntegrationTest",
                        HasUkrlpBeenCalledSuccessfully = false
                    };
                    context.Organisations.Add(newOrg);
                }

                context.SaveChanges();
            }
            
            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrganisationRepository repository = new OrganisationRepository(context);

                var ukprns = repository.GetUkprnsForOrgsWithNoUkrlpData();

                // assert
                Assert.AreEqual(numUkprnsExpected, ukprns.Count);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_GetOrganisationsAndSaveMethods_ShouldUpdateUkrlpData()
        {
            // arrange 
            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 25, 26 };

            var testOrg25 = new Organisation {Ukprn = 25, Upin = 25, TradingName = "TestTradingNameOrg25"};
            var testOrg26 = new Organisation {Ukprn = 26, Upin = 26, TradingName = "TestTradingNameOrg26"};

            using (var context = new OrganisationDomainDbContext())
            {
                // cleanup
                context.Organisations.Where(o => ukprnsToTest.Contains(o.Ukprn))
                    .ForEach(o => context.Organisations.Remove(o));

                // create test organisation records 
                context.Organisations.Add(testOrg25);
                context.Organisations.Add(testOrg26);
                context.SaveChanges();
            }

            // act 
            using (var context = new OrganisationDomainDbContext())
            {
                IOrganisationRepository repository = new OrganisationRepository(context);
                IReadOnlyCollection<Organisation> orgs = repository.GetOrganisations(ukprnsToTest);

                orgs.ForEach(
                    orgAndData =>
                    {
                        orgAndData.CompanyRegistrationNumber = $"TestCompanyRegNumber_{orgAndData.Ukprn.ToString()}";
                        orgAndData.HasUkrlpBeenCalledSuccessfully = true;
                    });

                repository.SaveChanges();
            }

            // assert
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org25 = context.Organisations.First(o => o.Ukprn == 25);

                Assert.AreEqual("TestCompanyRegNumber_25", org25.CompanyRegistrationNumber, "CompanyRegistrationNumber was not updated for Ukprn 25");
                Assert.AreEqual(true, org25.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not updated for Ukprn 25");

                Organisation org26 = context.Organisations.First(o => o.Ukprn == 26);

                Assert.AreEqual("TestCompanyRegNumber_26", org26.CompanyRegistrationNumber, "CompanyRegistrationNumber was not updated for Ukprn 26");
                Assert.AreEqual(true, org26.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not updated for Ukprn 26");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationRepository_GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp_ShouldReturnACorrectCount()
        {
            // Arrange
            CleanUpTestData();
            IList<Organisation> organisationsToRemoveTemporarily = new List<Organisation>();
            int returnedResoltHolder;

            using (var dbContext = new OrganisationDomainDbContext())
            {
                int ukprn = 1000000;
                organisationsToRemoveTemporarily = dbContext.Organisations.Where(o => !o.HasUkrlpBeenCalledSuccessfully).ToList();
                organisationsToRemoveTemporarily.ForEach(o => dbContext.Organisations.Remove(o));
                CreateAndSaveOrganisation(true, dbContext.Organisations, ukprn++);
                CreateAndSaveOrganisation(false, dbContext.Organisations, ukprn++);
                CreateAndSaveOrganisation(false, dbContext.Organisations, ukprn++);
                CreateAndSaveOrganisation(true, dbContext.Organisations, ukprn++);
                CreateAndSaveOrganisation(true, dbContext.Organisations, ukprn++);
                dbContext.SaveChanges();

                // Act
                returnedResoltHolder = new OrganisationRepository(new OrganisationDomainDbContext()).GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp().Result;
              
                organisationsToRemoveTemporarily.ForEach(o => dbContext.Organisations.Add(o));
                dbContext.SaveChanges();
            }

            // Assert
            Assert.AreEqual(2, returnedResoltHolder);
        }

        private static void CleanUpTestData()
        {
            using (var dbContext = new OrganisationDomainDbContext())
            {
                var organisationsQueryable =
                    dbContext.Organisations
                        .Where(o => o.TradingName == "TestTradingName")
                        .Select(o => new { o.OrganisationId })
                        .ToList()
                        .Select(o => new Organisation() { OrganisationId = o.OrganisationId });

                foreach (Organisation organisation in organisationsQueryable)
                {
                    dbContext.Organisations.Attach(organisation);
                    dbContext.Entry(organisation).State = EntityState.Deleted;
                }

                dbContext.SaveChanges();
            }
        }

        private void CreateAndSaveOrganisation(bool hasUkrlpBeenCalled, IDbSet<Organisation> organisationsDb, int ukprnAndUpin)
        {
            organisationsDb.Add(new Organisation()
            {
                HasUkrlpBeenCalledSuccessfully = hasUkrlpBeenCalled,
                TradingName = "TestTradingName",
                Ukprn = ukprnAndUpin,
                Upin = ukprnAndUpin
            });
        }
    }
}