namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using System;
    using System.Linq;
    using Extensions;
    using FluentAssertions;
    using IncrementContractVersionEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using UnitTests.Common;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private EntityReference _providerId = null;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetLastApprovedContractSubStatusAndTerminationDate_ShouldReturnNoneWhenThereIsNoLastApproved()
        {
            // arrange
            CrmContractRepository crmContractRepository = new CrmContractRepository(GetConnection());

            // act
            var optionSubStatus = crmContractRepository.GetLastApprovedContractSubStatusAndTerminationDate("some number");
            // assert
            optionSubStatus.IsNone.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetLastApprovedContractSubStatusAndTerminationDate_ShouldReturnSomeWhenThereIsALastApproved()
        {
            // arrange
            const string contractNumber = "Test CN 1234";
            const string subStatusName = "Under Termination";
            DateTime terminationDate = DateTime.UtcNow.ToDateTimeWithoutSeconds();
            DeleteContracts(contractNumber);
            var subStatusEntityRef = GetSubStatus(subStatusName);
            CreateTestContract(contractNumber, true, subStatusEntityRef, terminationDate);

            CrmContractRepository crmContractRepository = new CrmContractRepository(GetConnection());

            // act
            var optionSubStatus = crmContractRepository.GetLastApprovedContractSubStatusAndTerminationDate(contractNumber);
            // assert
            optionSubStatus.Match(Some: s =>
            {
                s.subStatus.Should().Be(subStatusName);
                s.terminationDate.Value.Should().Be(terminationDate);
            }, None:() => Assert.Fail("We should have found the substatus"));
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(() => organizationService.Delete(sfa_contract.EntityLogicalName, id)));
            }
        }

        private Guid CreateTestContract(string contractNumber, bool lastApprovedVersion, EntityReference subStatus, DateTime terminationDate)
        {
            IOrganizationService orgService = GetConnection();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_terminationdate = terminationDate,
                sfa_ProviderName = GetProvider(),
            };
            var contractId = orgService.Create(contract);
            contract = new sfa_contract
            {
                Id = contractId,
                sfa_SubStatus = subStatus
            };

            orgService.Update(contract);

            return contractId;
        }

        private EntityReference GetProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                if (_providerId == null)
                {
                    var orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                    _providerId = new EntityReference(Account.EntityLogicalName, orgId);
                }

                return _providerId;
            }
        }

        private EntityReference GetSubStatus(string subStatusName)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var id = crmContext.sfa_statusSet.Where(s => s.sfa_name == subStatusName)
                    .Select(a => a.Id)
                    .Single();

                return new EntityReference(sfa_status.EntityLogicalName, id);
            }
        }
    }
}
