namespace OrganisationDomain.Endpoint.Tests.Xrm.Repositories
{
    using System;
    using System.Linq;
    using Endpoint.Xrm.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class TeamRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void TeamRepository_GetContractManagersTeamAsEntityReference_ShouldReturnCorrectEntityReference()
        {
            // Arrange
            Guid guidExpected = GetGuidForContractManager();
            string logicalNameExpected = Team.EntityLogicalName;

            // Act
            TeamRepository teamRepo = new TeamRepository();
            EntityReference entityReference = teamRepo.GetContractManagersTeamAsEntityReference(new XrmServiceContext(GetOrganisationService()));

            // Assert
            Assert.AreEqual(guidExpected, entityReference.Id);
            Assert.AreEqual(logicalNameExpected, entityReference.LogicalName);
        }

        private Guid GetGuidForContractManager()
        {
            using (var xrmServiceContext = new XrmServiceContext(GetOrganisationService()))
            {
                return
                    xrmServiceContext.TeamSet.Where(t => t.Name == "Contract Managers Team")
                        .Select(t => t.Id)
                        .SingleOrDefault();
            }
        }

        private IOrganizationService GetOrganisationService()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
