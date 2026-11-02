using System.Collections;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using OrganisationDomain.Implementation.BusinessLogic;
using OrganisationDomain.Implementation.DataAccess;
using OrganisationDomain.Implementation.Exceptions;
using OrganisationDomain.Integration.Entities;

namespace OrganisationDomain.Implementation.Tests
{
    [TestClass]
    public class ProviderComparerTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod, TestCategory("UnitTest")]
        public void GetChanges_ShouldGetTheFctProvidersFromDataAccess()
        {
            // Arrange
            var comparer = new ProviderComparer();
            var repositoryMock = new Mock<IOrganisationRepository>();
            comparer.Repository = repositoryMock.Object;
            var providers = new List<ProviderSequence> { new ProviderSequence() };
            repositoryMock.Setup(r => r.GetFctProviderSummary()).Returns(providers);
            comparer.CpdsProviders = providers;
            
            // Act
            comparer.GetChanges();
            
            // Assert
            repositoryMock.Verify(r => r.GetFctProviderSummary(), Times.Once(), "Get Changes didn't call the data access");
        }

        [TestMethod,TestCategory("UnitTest")]
        public void GetChanges_ShouldReturnAListOfProvidersWhereChangedSequenceNumberButSameUpin_WhenComparedToFct()
        {
            
            ProviderComparer comparer = new ProviderComparer();
            comparer.CpdsProviders = new List<ProviderSequence>()
            {
                new ProviderSequence{Ukprn=0,Upin=0,SequenceNumber=1},
                new ProviderSequence{Ukprn=0,Upin=2,SequenceNumber=2},
                new ProviderSequence{Ukprn=1,Upin=1,SequenceNumber=1},
            };
            var repositoryMock = new Mock<IOrganisationRepository>();
            comparer.Repository = repositoryMock.Object;
            var fctProviders = new List<ProviderSequence>()
            {
                new ProviderSequence{Ukprn=0,Upin=0,SequenceNumber=0},
                new ProviderSequence{Ukprn=1,Upin=1,SequenceNumber=3}
            };
            repositoryMock.Setup(r => r.GetFctProviderSummary()).Returns(fctProviders);
            
            var providerChanges = comparer.GetChanges();

            Assert.IsTrue(providerChanges[0].Ukprn == 0
                && providerChanges[1].Ukprn == 1 && providerChanges.Count==2,"GetChanges didn't find the changed records");
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetChanges_ShouldNotReturnAListOfProviderChanges_WhenNoChanges()
        {
            // Arrange
            var comparer = new ProviderComparer();
            var repositoryMock = new Mock<IOrganisationRepository>();
            comparer.Repository = repositoryMock.Object;
            var providers = new List<ProviderSequence> { new ProviderSequence() };
            comparer.CpdsProviders = providers;
            repositoryMock.Setup(r => r.GetFctProviderSummary()).Returns(providers);
            
            // Act
            IList providerChanges = comparer.GetChanges();

            Assert.IsNull(providerChanges, "GetChanges should return null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetChanges_ShouldNotReturnAListOfProviderChanges_WhenNoCPDSProviders()
        {
            // Arrange
            var comparer = new ProviderComparer();
            var repositoryMock = new Mock<IOrganisationRepository>();
            comparer.Repository = repositoryMock.Object;
            var fctProviders = new List<ProviderSequence> { new ProviderSequence() };
            repositoryMock.Setup(r => r.GetFctProviderSummary()).Returns(fctProviders);

            IList providerChanges = null;
            try
            {
                // Act
                providerChanges = comparer.GetChanges();
            }
            catch (ProviderSummaryUnavailableException)
            {
                
            }

            Assert.IsNull(providerChanges, "GetChanges should return null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetChanges_ShouldNotReturnAListOfProviderChanges_WhenFCTProvidersIsNull()
        {
            // Arrange
            var comparer = new ProviderComparer();
            var repositoryMock = new Mock<IOrganisationRepository>();
            comparer.Repository = repositoryMock.Object;
            
            repositoryMock.Setup(r => r.GetFctProviderSummary()).Returns((List<ProviderSequence>)null);
            
            comparer.CpdsProviders = new List<ProviderSequence>();

            IList providerChanges = null;
            try
            {
                // Act
                providerChanges = comparer.GetChanges();
            }
            catch (ProviderSummaryUnavailableException)
            {
                
            }

            Assert.IsNull(providerChanges, "GetChanges should return null");
        }
    }
}
