using System.Collections.Generic;
using System.Xml.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using OrganisationDomain.Implementation.BusinessLogic;
using OrganisationDomain.Implementation.DataAccess;
using SFA.FCT.CrossDomain.Integration.Entities;

namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    [TestClass]
    public class RepositoryManagerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Update_ShouldCallRepository()
        {
            var organisation = new Organisation
            {
                OrganisationIdentifiers = new List<OrganisationIdentifiersOrganisationIdentifier>
                {
                        new OrganisationIdentifiersOrganisationIdentifier { OrganisationIdentifier = "12345678" }
                },
                OrganisationNames = new List<OrganisationNamesOrganisationName>
                {
                        new OrganisationNamesOrganisationName { OrganisationName = "ABC Provider" }
                }
            };

            var provider = new XDocument();

            var repositoryMock = new Mock<IOrganisationRepository>();

            var repositoryManager = new RepositoryManager(repositoryMock.Object);
            repositoryManager.Update(organisation, 1, provider);

            repositoryMock.Verify(x => x.UpdateOrganisation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()),
                Times.Once, "Update didn't call UpdateOrganisation once.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Update_ShouldCallRepository_WithOrganisationData()
        {
            var organisation = new Organisation
            {
                OrganisationIdentifiers = new List<OrganisationIdentifiersOrganisationIdentifier>
                {
                    new OrganisationIdentifiersOrganisationIdentifier
                    {
                        OrganisationIdentifier = "12345678"
                    }
                },
                OrganisationNames = new List<OrganisationNamesOrganisationName>
                {
                    new OrganisationNamesOrganisationName { OrganisationName = "ABC Provider" }
                }
            };

            var provider = XDocument.Parse("<provider></provider>");

            var repositoryMock = new Mock<IOrganisationRepository>();

            var repositoryManager = new RepositoryManager(repositoryMock.Object);
            repositoryManager.Update(organisation, 1, provider);

            repositoryMock.Verify(x => x.UpdateOrganisation(12345678, "ABC Provider", "<provider></provider>", 1),
                Times.Once, "Update didn't call UpdateOrganisation with Organisation data.");
        }
    }
}
