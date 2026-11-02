namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval.Services
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.InitiateContractApproval.Services;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class ContractCheckerServiceTests
    {
        private static EntityReference _providerEntityReference;
        private const string DummyPeriod = "FY1617";
        private const string FundingTypeCodeWithDefaultContractStartDate = "LEVY";
        private const string FundingPeriodNameWithDefaultContractStartDate = "LEVY1799";
        private const string NonLevyFsp = "NONLEVY2019";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCheckerServiceTests_GetContractCheckerServiceResult_ReturnFalseNoLevyWhenNotALevyContract()
        {
            // arrange
            const string childNumber = "Child-2222";
            const string fsp = "ALLF1819";

            DeleteContracts(childNumber);
            CreateTestContract(childNumber, GetFundingType("LOANS"), GetPeriod("AY1819"), 
                lastApprovedVersion: true, version: 1, subVersion: 0, isLatestVersion: true);

            var dbContext = new ContractManagementDbContext();
            var contractCheckerServiceUnderTest = CreateContractApprovedCheckerService();

            // act
            var contractCheckerServiceResult = contractCheckerServiceUnderTest.GetContractCheckerServiceResult(
                    childNumber, 
                    1, 
                    NonLevyFsp,
                    new ConnectionInfo(null, dbContext.Database.Connection));

            // assert
            Assert.IsFalse(contractCheckerServiceResult.IsLevy, "Result did not return IsLevy = false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCheckerServiceTests_GetContractCheckerServiceResult_ReturnTrueWhenLevyContractAndNotApprovedAndLastApprovedContractDoesNotIncludeAllocation()
        {
            // arrange
            const string childNumber = "Child-2222";

            DeleteContracts(childNumber);
            CreateTestContract(childNumber,
                GetFundingType(FundingTypeCodeWithDefaultContractStartDate),
                GetPeriod(FundingPeriodNameWithDefaultContractStartDate),
                lastApprovedVersion: false, version: 1,
                subVersion: 0, isLatestVersion: true);

            var dbContext = new ContractManagementDbContext();
            var contractCheckerServiceUnderTest = CreateContractApprovedCheckerService();

            // act
            var contractCheckerServiceResult = contractCheckerServiceUnderTest.GetContractCheckerServiceResult(
                childNumber,
                1,
                NonLevyFsp,
                new ConnectionInfo(null, dbContext.Database.Connection));

            // assert
            Assert.IsTrue(contractCheckerServiceResult.IsLevy, "Result did not return IsLevy = true");
            Assert.IsFalse(contractCheckerServiceResult.IsAllocationNew, "Result did not return IsAllocationNew = false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCheckerServiceTests_GetContractCheckerServiceResult_ReturnFalseWhenLevyContractAndApprovedAndNotLastApprovedContractDoesNotIncludeAllocation()
        {
            // arrange
            const string childNumber = "Child-2222";

            DeleteContracts(childNumber);
            var contractId = CreateTestContract(childNumber,
                GetFundingType(FundingTypeCodeWithDefaultContractStartDate),
                GetPeriod(FundingPeriodNameWithDefaultContractStartDate),
                lastApprovedVersion: true, version: 1,
                subVersion: 0, isLatestVersion: false);
            CreateContractAllocation(contractId, DateTime.Now.Date, "allocNumber", NonLevyFsp);

            CreateTestContract(childNumber,
                GetFundingType(FundingTypeCodeWithDefaultContractStartDate),
                GetPeriod(FundingPeriodNameWithDefaultContractStartDate),
                lastApprovedVersion: false, version: 2,
                subVersion: 0, isLatestVersion: true);

            var dbContext = new ContractManagementDbContext();
            var contractCheckerServiceUnderTest = CreateContractApprovedCheckerService();

            // act
            var contractCheckerServiceResult = contractCheckerServiceUnderTest.GetContractCheckerServiceResult(
                childNumber,
                2,
                NonLevyFsp,
                new ConnectionInfo(null, dbContext.Database.Connection));

            // assert
            Assert.IsTrue(contractCheckerServiceResult.IsLevy, "Result did not return IsLevy = true");
            Assert.IsFalse(contractCheckerServiceResult.IsAllocationNew, "Result did not return IsAllocationNew = false");
        }

        private static Guid CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, int subVersion, bool isLatestVersion)
        {
            IOrganizationService organizationService = GetOrgService();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_SubVersion = subVersion,
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period),
                sfa_LatestVersion = false
            };

            Guid contractId = organizationService.Create(contract);

            organizationService.Update(new sfa_contract
            {
                Id = contractId,
                sfa_LatestVersion = isLatestVersion
            });

            return contractId;
        }

        private static Guid CreateContractAllocation(Guid contractId, DateTime setupDateTime, string allocationNumber, string fspCode)
        {
            var allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = allocationNumber,
                sfa_startdate = setupDateTime,
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(fspCode)
            };

            return GetOrgService().Create(allocation);
        }

        private static EntityReference GetFundingStreamPeriodEntityRef(string fspCode)
        {
            using (var crmContext = new XrmServiceContext(GetOrgService()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        private static Guid GetPeriod(string periodName)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetOrgService()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }

        private static ContractCheckerService CreateContractApprovedCheckerService()
        {
            var fundingTypeFundingPeriodQueryRepository = FundingTypeFundingPeriodQueryRepository.CreateInstance(new ContractManagementDbContext());

            return new ContractCheckerService(fundingTypeFundingPeriodQueryRepository, new CrmContractRepository(GetOrgService()));
        }

        private static Guid GetFundingType(string fundingTypeCode)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetOrgService()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private static EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference != null) return _providerEntityReference;
            using (XrmServiceContext crmContext = new XrmServiceContext(GetOrgService()))
            {
                _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
            }

            return _providerEntityReference;
        }

        private static IOrganizationService GetOrgService()
        {
            return SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => organizationService.Delete(sfa_contract.EntityLogicalName, id));
            }
        }
    }
}
