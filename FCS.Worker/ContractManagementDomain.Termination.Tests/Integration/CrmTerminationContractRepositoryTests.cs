namespace ContractManagementDomain.Termination.Tests.Integration
{
    using System;
    using System.Configuration;
    using System.Linq;
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class CrmTerminationContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmTerminationContractRepository_ShouldGetSimpleContractTerminationInfo()
        {
            // arrange
            const string contractNumber = "Test - CNx";
            const int contractVersion = 1;
            const int contractSubVersion = 1;
            DateTime terminationDate = new DateTime(2018, 1, 1, 0,0, 0, DateTimeKind.Utc);
            DeleteContract(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion, contractSubVersion, terminationDate);
            CrmTerminationContractRepository crmTerminationContractRepository = new CrmTerminationContractRepository(GetCrmConnection());
            
            // act
            SimpleContractTerminationInfo info = crmTerminationContractRepository.GetSimpleContractTerminationInfo(contractNumber, contractVersion,
                contractSubVersion);

            // assert
            Assert.AreEqual(true, info.IsLatest, "The latest version has not been returned");
            Assert.AreEqual(terminationDate, info.TerminationDate, "The termination date is not correct");
        }

        private static Guid CreateContract(string contractNumber, int version, int subVersion, DateTime? terminationDate)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1",
                sfa_terminationdate = terminationDate
            };

            Guid contractId = GetCrmConnection().Create(contract);

            return contractId;
        }

        private static EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private static void DeleteContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_contractId.Value)
                    .ForEach(id => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
