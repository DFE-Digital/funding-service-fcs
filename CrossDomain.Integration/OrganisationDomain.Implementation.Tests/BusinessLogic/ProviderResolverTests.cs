namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System.Xml.Linq;
    using Implementation.Services;
    using Integration.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using OrganisationDomain.Implementation.BusinessLogic;
    using OrganisationDomain.Implementation.DataAccess;
    using Moq;
    using OrganisationDomain.Implementation.Mappers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;
    using Castle.MicroKernel.SubSystems.Conversion;

    [TestClass]
    public class ProviderResolverTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public async Task ProviderResolver_GetByUkprn_ShouldCallRepositoryGetDetailByUkprn()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Organisation orgReturned = new  Organisation
            {
                Ukprn=1,
                OrganisationId=1,
                SequenceNumber=1,
                TradingName="Tn"
            };
            
            repoMock.Setup(x=>x.GetDetailByUkprn(1)).Returns(orgReturned);
            ProviderResolver resolver = new ProviderResolver(null)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object,
                Logger = Mock.Of<ILogger>()
            };

            // act
            await resolver.GetByUkprn(1);

            // assert
            repoMock.Verify(x => x.GetDetailByUkprn(1), Times.Once(), "GetByUkprn didn't call GetDetailByUkprn on the repository");
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ProviderResolver_GetByUkprn_ShouldCallMapperMapDbEntityToCorpSchema()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Organisation orgReturned = new Organisation
            {
                Ukprn = 1,
                OrganisationId = 1,
                SequenceNumber = 1,
                TradingName = "Tn"
            };

            repoMock.Setup(x => x.GetDetailByUkprn(1)).Returns(orgReturned);
            ProviderResolver resolver = new ProviderResolver(null)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object,
                Logger = Mock.Of<ILogger>()
            };

            // act
            await resolver.GetByUkprn(1);

            // assert
            mapperMock.Verify(x => x.MapDbEntityToCorpSchema(orgReturned), Times.Once(), "GetByUkprn didn't call MapDbEntityToCorpSchema on the mapper");
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ProviderResolver_GetByUkprn_ShouldCallCpds_IfDbEntityIsNull()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Mock<ICpdsOrganisationRetriever> retrieverMock = new Mock<ICpdsOrganisationRetriever>();
            repoMock.Setup(x => x.GetDetailByUkprn(1)).Returns((Organisation)null);
            ProviderResolver resolver = new ProviderResolver(retrieverMock.Object)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object,
                Logger = Mock.Of<ILogger>()
            };

            // act
            await resolver.GetByUkprn(1);

            // assert
            retrieverMock.Verify(x => x.GetProviderByUkprn(1), Times.Once(), "GetByUkprn didn't call GetProviderByUkprn on the retriever");
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ProviderResolver_GetByUkprn_ShouldCallDbUpdate_IfDbEntityIsNullButCpdsIsNotNull()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Mock<ICpdsOrganisationRetriever> retrieverMock = new Mock<ICpdsOrganisationRetriever>();
            Mock<IOrgSupplementaryDataService> orgSupplementaryDataService = new Mock<IOrgSupplementaryDataService>();

            orgSupplementaryDataService.Setup(ds => ds.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, false));

            Organisation orgReturned = new Organisation
            {
                Ukprn = 1,
                OrganisationId = 1,
                SequenceNumber = 1,
                TradingName = "Trading Name 1",
                Status = "Active",
                Type = "Public Limited Company"
            };

            const string cpdsXml = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                                   "<Provider ProviderSequenceNumber='741101'>" +
                                   " <Upin>002</Upin>" +
                                   " <UKPRN>12345678</UKPRN>" +
                                   " <TradingName>National Employer Service</TradingName>" +
                                   " </Provider>" +
                                   " <Provider ProviderSequenceNumber='610288'>" +
                                   "  <Upin>003</Upin>" +
                                   " <UKPRN>0</UKPRN>" +
                                   "  <TradingName>National Apprenticeship Service</TradingName>" +
                                   "</Provider>" +
                                   "</ProviderDataSetV2>";

            mapperMock.Setup(x => x.MapProviderXmlToDbEntity(It.IsAny<XDocument>())).Returns(orgReturned);
            retrieverMock.Setup(x => x.GetProviderByUkprn(1)).Returns(XDocument.Parse(cpdsXml));
            repoMock.Setup(x => x.GetDetailByUkprn(1)).Returns<Organisation>(null);

            ProviderResolver resolver = new ProviderResolver(retrieverMock.Object)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object,
                OrgSupplementaryDataService = orgSupplementaryDataService.Object,
                Logger = Mock.Of<ILogger>()
            };

            // act
           await resolver.GetByUkprn(1);

            // assert
            repoMock.Verify(x => x.CreateOrganisation(orgReturned), Times.Once(), "GetByUkprn didn't call UpdateOrganisation on the repository.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task  ProviderResolver_GetByUkprn_ShouldReturnNull_IfDbEntityIsNullAndCpdsIsNull()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Mock<ICpdsOrganisationRetriever> retrieverMock = new Mock<ICpdsOrganisationRetriever>();

            mapperMock.Setup(x => x.MapProviderXmlToDbEntity(It.IsAny<XDocument>())).Returns<Organisation>(null);
            retrieverMock.Setup(x => x.GetProviderByUkprn(1)).Returns<XDocument>(null);
            repoMock.Setup(x => x.GetDetailByUkprn(1)).Returns<Organisation>(null);
            ProviderResolver resolver = new ProviderResolver(retrieverMock.Object)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object,
                Logger = Mock.Of<ILogger>()
            };

            // act
            organisation result = await resolver.GetByUkprn(1);

            // assert
            Assert.IsNull(result, "GetByUkprn didn't return null.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderResolver_GetByOrgId_ShouldCallRepositoryGetDetailByUkprn()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Organisation orgReturned = new Organisation
            {
                Ukprn = 1,
                OrganisationId = 1,
                SequenceNumber = 1,
                TradingName = "Tn",
                Status = "Active",
                Type = "Public Limited Company"
            };

            repoMock.Setup(x => x.GetDetailByOrgId("C1")).Returns(orgReturned);
            ProviderResolver resolver = new ProviderResolver(null)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object
            };

            // act
            resolver.GetByOrgId("C1");

            // assert
            repoMock.Verify(x => x.GetDetailByOrgId("C1"), Times.Once(), "GetByOrgId didn't call GetDetailByOrgId on the repository");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderResolver_GetByOrgId_ShouldReturnNull_WhenRepositoryReturnsNull()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            
            repoMock.Setup(x => x.GetDetailByOrgId("C1")).Returns((Organisation)null);
            ProviderResolver resolver = new ProviderResolver(null)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object
            };

            // act
            organisation result= resolver.GetByOrgId("C1");

            // assert
            Assert.IsTrue(result == null, "GetByOrgId didn't return null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderResolver_GetByOrgId_ShouldReturnTheMappedOrg_WhenRepositoryOrgIsNotNull()
        {
            // arrange
            Mock<IOrganisationRepository> repoMock = new Mock<IOrganisationRepository>();
            Mock<ICpdsMapper> mapperMock = new Mock<ICpdsMapper>();
            Organisation orgReturned = new Organisation
            {
                Ukprn = 1,
                OrganisationId = 1,
                SequenceNumber = 1,
                TradingName = "Tn",
                
            };
            organisation orgToReturn = new organisation();
            mapperMock.Setup(x => x.MapDbEntityToCorpSchema(orgReturned)).Returns(orgToReturn);
            repoMock.Setup(x => x.GetDetailByOrgId("C1")).Returns(orgReturned);
            ProviderResolver resolver = new ProviderResolver(null)
            {
                Repository = repoMock.Object,
                Mapper = mapperMock.Object
            };

            // act
            organisation result = resolver.GetByOrgId("C1");

            // assert
            Assert.IsTrue(result == orgToReturn, "GetByOrgId didn't return the mapped org");
        }
    }
}
