namespace FCT.Operations.Integrity.Tests.Repositories
{
    using SFA.FCT.Operations.Integrity.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCS.Worker.Common.Crm;
    using System;
    using System.Threading;

    [TestClass]
    public class CrmDuplicateContractRepositoryTests
    {
        private EntityReference _providerId;

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmDuplicateContractRepository_ShouldReturnAListOfDuplicateContractNumbers()
        {
            // Arrange
            const int sixtySeconds = 60000;

            const string contractNumberA = "Duplicate_Test_A";
            const int versionA = 1;
            const int subversionA = 0;
            SetupDuplicateCrmContract(contractNumberA, versionA, subversionA);

            const string contractNumberB = "Duplicate_Test_B";
            const int versionB = 1;
            const int subversionB = 0;
            SetupDuplicateCrmContract(contractNumberB, versionB, subversionB);

            // Act
            var assertDuplicatedContracts = new CrmDuplicateContractRepository(new LocalConfig()).GetDuplicatedContracts();

            // Assert
            Thread.Sleep(sixtySeconds);

            Assert.IsTrue(assertDuplicatedContracts.Count > 0,  "A list of duplicated contracts were not returned");

            var assertDuplicateContractA = assertDuplicatedContracts.SingleOrDefault(dc => dc.ContractNumber == contractNumberA && dc.Version == versionA && dc.SubVersion == subversionA);
            Assert.IsNotNull(assertDuplicateContractA, $"The asserted duplicated contract was not returned for contractNumber : {contractNumberA}");

            var assertDuplicateContractB = assertDuplicatedContracts.SingleOrDefault(dc => dc.ContractNumber == contractNumberB && dc.Version == versionB && dc.SubVersion == subversionB);
            Assert.IsNotNull(assertDuplicateContractB, $"The asserted duplicated contract was not returned for contractNumber : {contractNumberB}");

            DeleteContracts("Duplicate_Test_A");

            DeleteContracts("Duplicate_Test_B");
        }

        private void SetupDuplicateCrmContract(string contractNumber, int version, int subversion)
        {
            DeleteContracts(contractNumber);
            CreateTestContract(contractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: version, subVersion: subversion);
            CreateTestContract(contractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: version, subVersion: subversion);
        }

        private static void DeleteContracts(string contractNumber)
        {
            var organizationService = GetConnection();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => organizationService.Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private void CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, int subVersion)
        {
            var orgService = GetConnection();
            var contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetProvider(),
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period)
            };

            orgService.Create(contract);
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

        private static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static Guid GetFundingType(string fundingTypeCode)
        {
            using (var serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private static Guid GetPeriod(string periodName)
        {
            using (var serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }
    }
}