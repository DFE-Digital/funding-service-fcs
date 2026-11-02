namespace OrganisationDomain.Implementation.Tests.DataAccess
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.Entities;
    using OrganisationDomain.Implementation.DataAccess;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class OrganisationRepositoryTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void OrganisationRepository_GetFctProviderSummary_ShouldQueryTheContextForAllOrganisations()
        {
            // arrange
            List<Organisation> data = new List<Organisation> 
            { 
                new Organisation { Ukprn = 1, Upin=10}, 
                new Organisation { Ukprn = 2, Upin=20 }, 
                new Organisation { Ukprn = 3, Upin=30 }, 
            };

            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(data.ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository
            {
                OrganisationDomainDbContext = contextMock.Object
            };

            // act
            List<ProviderSequence> result = repository.GetFctProviderSummary();

            // assert
            Assert.IsTrue(result.Count == 3, "GetFctProviderSummary didn't return all the organisations");
            Assert.IsTrue(result.Any(x=>x.Ukprn==1 && x.Upin==10)
                && result.Any(x => x.Ukprn == 2 && x.Upin == 20)
                && result.Any(x => x.Ukprn == 3 && x.Upin == 30), "GetFctProviderSummary didn't return the correct organisations");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_GetDetailByUkprn_ShouldQueryTheContextForTheSpecificOrganisation()
        {
            // arrange
            List<Organisation> data = new List<Organisation> 
            { 
                new Organisation { Ukprn = 1}, 
                new Organisation { Ukprn = 2 }, 
                new Organisation { Ukprn = 3 }, 
            };

            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(data.ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository
            {
                OrganisationDomainDbContext = contextMock.Object
            };

            // act
            Organisation result = repository.GetDetailByUkprn(2);

            // assert
            Assert.IsTrue(result.Ukprn==2, "GetDetailByUkprn get the correct organisation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_GetDetailByOrgId_ShouldQueryTheContextForTheSpecificOrganisation()
        {
            // arrange
            List<Organisation> data = new List<Organisation> 
            { 
                new Organisation { Ukprn = 1, OrganisationId = 1}, 
                new Organisation { Ukprn = 2, OrganisationId = 2 }, 
                new Organisation { Ukprn = 3, OrganisationId = 3 }, 
            };
            
            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(data.ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository
            {
                OrganisationDomainDbContext = contextMock.Object
            };
           
            // act
            Organisation result = repository.GetDetailByOrgId("ORG0000002");

            // assert
            Assert.IsTrue(result.OrganisationId == 2 && result.FormattedOrganisationId == "ORG0000002", "GetDetailByOrgId get the correct organisation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_UpdateOrganisation_ShouldUpdateTheRecord_WhenAMatchingOrgFound()
        {
            // arrange
            List<Organisation> data = new List<Organisation> 
            { 
                new Organisation { Ukprn = 1, TradingName = "Trading Name 1" }, 
                new Organisation { Ukprn = 2, TradingName= "Trading Name 1" }, 
                new Organisation { Ukprn = 3, TradingName= "Trading Name 1" } 
            };

            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(data.ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository
            {
                OrganisationDomainDbContext = contextMock.Object
            };

            const int ukprn = 1;
            const string tradingName = "Trading Name 4";
            const int sequenceNumber = 123;
            const string status = "Active";
            const string providerType = "School-Community";

            // act
            repository.UpdateOrganisation(new Organisation
            {
                Ukprn = ukprn,
                TradingName = tradingName,
                SequenceNumber = sequenceNumber,
                Status = status,
                Type = providerType
            });

            // assert
            Organisation updatedRecord = data.Single(x => x.Ukprn == ukprn);
            Assert.AreEqual(tradingName, updatedRecord.TradingName, "TradingName was not updated");
            Assert.AreEqual(sequenceNumber, updatedRecord.SequenceNumber, "Sequence number was not updated");
            Assert.AreEqual(status ,updatedRecord.Status, "Status was not updated");
            Assert.AreEqual(providerType ,updatedRecord.Type, "Provider type was not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_UpdateOrganisation_ShouldCallSaveChangesOnDbContext()
        {
            // arrange
            List<Organisation> data = new List<Organisation> 
            { 
                new Organisation { Ukprn = 1,TradingName = "Trading Name 1" }, 
                new Organisation { Ukprn = 2,TradingName= "Trading Name 1" }, 
                new Organisation { Ukprn = 3,TradingName= "Trading Name 1" }
            };

            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(data.ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository
            {
                OrganisationDomainDbContext = contextMock.Object
            };

            const int ukprn = 1;
            const string tradingName = "Trading Name 4";
            const int sequenceNumber = 123;

            // act
            repository.UpdateOrganisation(new Organisation
            {
                Ukprn = ukprn,
                TradingName = tradingName,
                SequenceNumber = sequenceNumber,
            });

            // assert
            contextMock.Verify(x => x.SaveChanges(), Times.Once, "UpdateOrganisation didn't call SaveChanges.");
        }
      
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_CreateOrganisation_ShouldCallAddOnDbContext()
        {
            // arrange
            Mock<IDbSet<Organisation>> dbSetMock = new List<Organisation>().ToMockIDbSet();
            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(dbSetMock.Object);

            OrganisationRepository repository = new OrganisationRepository { OrganisationDomainDbContext = contextMock.Object };

            const int ukprn = 4;
            const string tradingName = "Trading Name 4";
            const int sequenceNumber = 1;

            // act
            repository.CreateOrganisation(new Organisation
            {
                Ukprn = ukprn,
                TradingName = tradingName,
                SequenceNumber = sequenceNumber
            });

            // assert
            dbSetMock.Verify(x => x.Add(It.IsAny<Organisation>()), Times.Once(), "CreateOrganisation didn't call Add on DbSet.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_CreateOrganisation_ShouldCallSaveChangesOnDbContext()
        {
            // arrange
            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(new List<Organisation>().ToMockIDbSet().Object);

            OrganisationRepository repository = new OrganisationRepository { OrganisationDomainDbContext = contextMock.Object };

            const int ukprn = 4;
            const string tradingName = "Trading Name 4";
            const int sequenceNumber = 1;

            // act
            repository.CreateOrganisation(new Organisation
            {
                Ukprn = ukprn,
                TradingName = tradingName,
                SequenceNumber = sequenceNumber
            });

            // assert
            contextMock.Verify(x => x.SaveChanges(), Times.Once(), "CreateOrganisation didn't call SaveChanges.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationRepository_CreateOrganisation_ShouldCreateNewOrganisationInDbContext()
        {
            // arrange
            Mock<IDbSet<Organisation>> dbSetMock = new List<Organisation>().ToMockIDbSet();

            Mock<IOrganisationDomainDbContext> contextMock = new Mock<IOrganisationDomainDbContext>();
            contextMock.SetupGet(x => x.Organisations).Returns(dbSetMock.Object);

            OrganisationRepository repo = new OrganisationRepository { OrganisationDomainDbContext = contextMock.Object };

            const int ukprn = 4;
            const string tradingName = "Trading Name 4";
            const int sequenceNumber = 1;
            const string status = "Active";
            const string type = "Public limited company";

            // act
            repo.CreateOrganisation(new Organisation
            {
                Ukprn = ukprn,
                TradingName = tradingName,
                SequenceNumber = sequenceNumber,
                Status = status,
                Type = type
            });

            // assert
            dbSetMock.Verify(x => x.Add(It.Is<Organisation>
                (y => y.Ukprn.Equals(ukprn))), $"Add was not called with a UKPRN of {ukprn}.");
            dbSetMock.Verify(x => x.Add(It.Is<Organisation>
                (y => y.TradingName.Equals(tradingName))), $"Add was not called with a Trading Name of {tradingName}.");
            dbSetMock.Verify(x => x.Add(It.Is<Organisation>
                (y => y.SequenceNumber.Equals(sequenceNumber))), $"Add was not called with a sequence number of {sequenceNumber}.");
            dbSetMock.Verify(x => x.Add(It.Is<Organisation>
                (y => y.Status.Equals(status))), $"Add was not called with a Trading Name of {tradingName}.");
            dbSetMock.Verify(x => x.Add(It.Is<Organisation>
                (y => y.Type.Equals(type))), $"Add was not called with a Trading Name of {tradingName}.");
        }
    }
}
