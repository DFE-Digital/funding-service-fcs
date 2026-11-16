namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System.Linq;
    using System.Net;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using Implementation.Services;
    using Integration.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ProviderResolverIntegrationTests
    {
        static ProviderResolverIntegrationTests()
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderResolver_ShouldInsertNewOrganisation()
        {
            const int ukprn = 10021107;
            var orgSupplementaryDataService = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataService.Setup(ds => ds.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, false));

            // arrange
            using (var context = new OrganisationDomainDbContext())
            {
                foreach (var organisation in context.Organisations.Where(o => o.Ukprn == ukprn))
                {
                    context.Organisations.Remove(organisation);
                }

                context.SaveChanges();
            }

            ProviderResolver providerResolver = new ProviderResolver(new CpdsStub(Mock.Of<ILogger>(), new AzureTableStore(), new CpdsProviderConverter()))
            {
                Logger = new Mock<ILogger>().Object,
                Mapper = new CpdsMapper(),
                Repository = new OrganisationRepository
                {
                    OrganisationDomainDbContext = new OrganisationDomainDbContext()
                },
                OrgSupplementaryDataService = orgSupplementaryDataService.Object
            };

            // act           
            providerResolver.GetByUkprn(ukprn);

            // assert
            using (var context = new OrganisationDomainDbContext())
            {
                Assert.IsTrue(context.Organisations.Any(o => o.Ukprn == ukprn));                
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderResolver_ShouldUpdateSupplementaryData()
        {
            const int ukprn = 10021107;
            const string companyRegNumberTest = "Test CN";
            const string charityNumberTest = "Test CH";
            var orgSupplementaryDataService = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataService.Setup(ds => ds.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumberTest, charityNumberTest, true));

            // arrange
            using (var context = new OrganisationDomainDbContext())
            {
                foreach (var organisation in context.Organisations.Where(o => o.Ukprn == ukprn))
                {
                    context.Organisations.Remove(organisation);
                }

                context.SaveChanges();
            }

            ProviderResolver providerResolver = new ProviderResolver(new CpdsStub(Mock.Of<ILogger>(), new AzureTableStore(), new CpdsProviderConverter()))
            {
                Logger = new Mock<ILogger>().Object,
                Mapper = new CpdsMapper(),

                Repository = new OrganisationRepository
                {
                    OrganisationDomainDbContext = new OrganisationDomainDbContext()
                },
                OrgSupplementaryDataService = orgSupplementaryDataService.Object
            };

            // act           
            providerResolver.GetByUkprn(ukprn);

            // assert
            using (var context = new OrganisationDomainDbContext())
            {
                Assert.IsTrue(context.Organisations.Any(o => o.Ukprn == ukprn), "An org for this ukprn has not been added");
                var org = context.Organisations.Single(o => o.Ukprn == ukprn);
                Assert.AreEqual(companyRegNumberTest, org.CompanyRegistrationNumber, "The company reg number has not been updated");
                Assert.AreEqual(charityNumberTest, org.CharityNumber, "The charity number has not been updated");
            }
        }
    }
}
