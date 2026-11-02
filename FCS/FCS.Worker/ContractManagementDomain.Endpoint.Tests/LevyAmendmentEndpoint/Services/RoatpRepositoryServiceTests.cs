namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class RoatpRepositoryServiceTests
    {
        private const string MainProviderType = "MainProvider";
        private const string SupportingEmployerType = "SupportingProvider";
        private const string EmployerProviderType = "EmployerProvider";

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task RoatpRepositoryService_PopulateValidUkprnsFromRoatp_WhenSomeProvidersAreNoLongerRoatPMainProviders_ShouldFilterThemOffList()
        {
            // arrange
            string expectedUkprn1 = "18712021";
            string expectedUkprn2 = "18712022";
            const string unexpectedUkprn1 = "12345678";
            const string unexpectedUkprn2 = "18742488";

            string[] expectedUkprns = { expectedUkprn1, expectedUkprn2 };
            string[] unexpectedUkprns = { unexpectedUkprn1, unexpectedUkprn2 };

            DeleteRowsForGivenUkprns(expectedUkprns.Union(unexpectedUkprns).ToList());

            List<RoatpProvider> providers = new List<RoatpProvider>()
            {
                new RoatpProvider(expectedUkprn1, MainProviderType),
                new RoatpProvider(expectedUkprn2, EmployerProviderType),
                new RoatpProvider(unexpectedUkprn1, SupportingEmployerType),
                new RoatpProvider(unexpectedUkprn2, SupportingEmployerType),
            };

            using (var context = new ContractManagementDbContext())
            {
                RoatpRepositoryService service =
                    new RoatpRepositoryService(new RoatpProviderRepository());

                // act
                await service.PopulateValidUkprnsFromRoatp(providers, new ConnectionInfo(null, context.Database.Connection));
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                expectedUkprns.ForEach(ukprn =>
                {
                    var provider = context.RoatpProviders.Find(ukprn);
                    Assert.IsNotNull(provider, $"Ukprn {ukprn} was not found in the repository");
                });
                unexpectedUkprns.ForEach(ukprn =>
                {
                    var provider = context.RoatpProviders.Find(ukprn);
                    Assert.IsNull(provider, $"Ukprn {ukprn} was unexpectedly found in the repository");
                });
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public async Task RoatpRepositoryService_PopulateValidUkprnsFromRoatp_UsingRealData()
        {
            using (var context = new ContractManagementDbContext())
            {
                // arrange
                string mainProviderUkprn = "10000020";
                string supportProviderUkprn = "10000182";
                string employerProviderUkprn = "10000688";
                List<string> ukprns = new List<string> { mainProviderUkprn, supportProviderUkprn, employerProviderUkprn };
                DeleteRowsForGivenUkprns(ukprns);

                RoatpApiHttpClient roatpClient = new RoatpApiHttpClient();
                IReadOnlyCollection<RoatpProvider> allProviders = roatpClient.GetAllProviders().Result;

                List<RoatpProvider> roatpProviders = allProviders.Where(p => ukprns.Contains(p.Ukprn)).ToList();


                // act
                RoatpRepositoryService service = new RoatpRepositoryService(new RoatpProviderRepository());
                await service.PopulateValidUkprnsFromRoatp(roatpProviders, new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.IsNotNull(context.RoatpProviders.Find(mainProviderUkprn));
                Assert.IsNotNull(context.RoatpProviders.Find(employerProviderUkprn));
                Assert.IsNull(context.RoatpProviders.Find(supportProviderUkprn));
            }
        }

        private void DeleteRowsForGivenUkprns(List<string> ukprnsToDelete)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.RoatpProviders.RemoveWhere(p => ukprnsToDelete.Contains(p.Ukprn));
                context.SaveChanges();
            }
        }
    }
}