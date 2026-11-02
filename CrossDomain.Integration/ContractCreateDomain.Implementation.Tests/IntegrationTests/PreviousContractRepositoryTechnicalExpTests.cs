namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Optional;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    [TestClass]
    public class PreviousContractRepositoryTechnicalExpTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldGetBackTheDetailsWeExpect()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(organizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLatestContract("ESIF-893");

            int i = 0;
        }
    }
}
