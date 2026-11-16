namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Endpoint.ArchiveDocument.Services;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using UnitTests.Common;

    [TestClass]
    public class PolicyQueryServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyQueryService_ShouldGenerateDocumentationForContract_ShouldReturnTrueWhenDocumentsRequired()
        {
            // arrange
            var service = new PolicyQueryService();
            var connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["DocumentsDomainDbContext"].ConnectionString));

            ContractApprovedEvent contractApprovedEvent = TestResource.FromJson<ContractApprovedEvent>(
                "DocumentsDomain.Endpoint.Tests.Resources", "ContractApprovedEvent_AEB-CL1819.json");
            Contract masterContract = contractApprovedEvent.CorporateContract;

            // act
            bool shouldGenerateDocumentationForContract = service.ShouldGenerateDocumentationForContract(masterContract, connectionInfo).Result;

            // assert
            shouldGenerateDocumentationForContract.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyQueryService_ShouldGenerateDocumentationForContract_ShouldReturnFalseWhenDocumentsNotRequired()
        {
            // arrange
            var service = new PolicyQueryService();
            var connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["DocumentsDomainDbContext"].ConnectionString));

            ContractApprovedEvent contractApprovedEvent = TestResource.FromJson<ContractApprovedEvent>(
                "DocumentsDomain.Endpoint.Tests.Resources", "ContractApprovedEvent_EOF1417.json");
            Contract masterContract = contractApprovedEvent.CorporateContract;

            // act
            bool shouldGenerateDocumentationForContract = service.ShouldGenerateDocumentationForContract(masterContract, connectionInfo).Result;

            // assert
            shouldGenerateDocumentationForContract.Should().BeFalse();
        }
    }
}
