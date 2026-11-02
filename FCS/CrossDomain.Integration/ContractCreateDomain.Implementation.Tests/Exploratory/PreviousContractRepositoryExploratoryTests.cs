namespace ContractCreateDomain.Implementation.Tests.Exploratory
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Optional;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class PreviousContractRepositoryExploratoryTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PreviousContractRepository_GetLatestContract_ShouldNotErrorWhenContractDoesNotExist()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const string masterContractNumber = "MXX=Test";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(organizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLatestContract(contractNumber);

            // assert
            latestContract.Match(some: x => { Assert.Fail("GetLatestContract method incorrectly returned previous contract information when the contract did not exist"); }, none: () => { });
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PreviousContractRepository_GetLastApprovedContract_ShouldNotErrorWhenContractDoesNotExist()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const string masterContractNumber = "MXX=Test";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(organizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLastApprovedContract(contractNumber);

            // assert
            latestContract.Match(some: x => { Assert.Fail("GetLastApprovedContract method incorrectly returned previous contract information when the contract did not exist"); }, none: () => { });
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                            c => c.sfa_number == contractNumber)
                        .Select(c => c.Id);

                matchingContracts.ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }
    }
}
