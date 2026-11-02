namespace ContractManagementDomain.Termination.Tests.Integration
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ContractsManagerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetCorporateContractForSpecificVersion_ShouldGetTheCorrectContract()
        {
            // arrange
            const string contactNumber = "Test - C1";
            const string masterContractNumber = "Master - test2";
            const int version = 1;
            const int subVersion = 0;
            DateTime terminationDate = new DateTime(2018, 10, 9, 0, 0, 0, DateTimeKind.Utc);
            sfa_TerminationReasons versionOneTerminationReason = sfa_TerminationReasons.NoticefromAgency;

            DeleteContract(contactNumber);
            DeleteContract(masterContractNumber);
            Guid masterContractId = CreateMasterContract(masterContractNumber, version, subVersion);
            CreateContract(contactNumber, version, subVersion, sfa_contractstatus.Approved, "Under Termination", masterContractId, terminationDate, versionOneTerminationReason);
            CreateContract(contactNumber, version + 1, subVersion, sfa_contractstatus.Approved, "Under Termination", masterContractId, terminationDate.AddDays(1), sfa_TerminationReasons.NoticefromProvider);
            CreateContract(contactNumber, version + 2, subVersion, sfa_contractstatus.Approved, "Under Termination", masterContractId, terminationDate.AddDays(2), sfa_TerminationReasons.ProviderChange);
            ContractsManager contractsManager = new ContractsManager(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            var masterContract = contractsManager.GetCorporateContractForSpecificVersion(new ContractIdentifier(contactNumber, version, subVersion));

            // assert
            Assert.AreEqual(masterContractNumber, masterContract.contractNumber, "The master contract number is wrong");
            var childContracts = masterContract.contracts;
            Assert.AreEqual(1, childContracts.Count, "The number of child contracts is wrong");
            Assert.AreEqual(version, childContracts.Single().contractVersionNumber, "The contractVersionNumber of child contracts is wrong");
            Assert.AreEqual(subVersion, childContracts.Single().contractSubVersionNumber, "The contractSubVersionNumber of child contracts is wrong");
            Assert.IsTrue(terminationDate.IsDateTimeEqualTo(childContracts.Single().TerminationDate.GetValueOrDefault()), "The TerminationDate of child contracts is wrong");
            Assert.AreEqual(versionOneTerminationReason.ToString(), childContracts.Single().TerminationReason, "The TerminationReason of child contracts is wrong");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetCorporateContractForSpecificVersion_ShouldGetAllocationTerminationValues()
        {
            // arrange
            const string contractNumber = "MAIN-1234";
            const string masterContractNumber = "ESFA-1234";
            const string allocationNumber = "ALLOC-1234";
            const int version = 1;
            const int subVersion = 0;
            DateTime stopNewStartsDate = new DateTime(2020, 10, 31, 0, 0, 0, DateTimeKind.Utc);
            const string newStartsSuspendedReason = "Inadequate Financial Health";
            DateTime fundingCessationDate = new DateTime(2020, 12, 31, 0, 0, 0, DateTimeKind.Utc); ;

            DeleteAllocation(allocationNumber);
            DeleteContract(contractNumber);
            DeleteContract(masterContractNumber);
            Guid masterContractId = CreateMasterContract(masterContractNumber, version, subVersion);
            Guid childContractId = CreateContract(contractNumber, version, subVersion, sfa_contractstatus.Approved, "Approved", masterContractId);
            CreateAllocation(childContractId, allocationNumber, stopNewStartsDate, newStartsSuspendedReason, fundingCessationDate);

            ContractsManager contractsManager = new ContractsManager(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            contract masterContract = contractsManager.GetCorporateContractForSpecificVersion(new ContractIdentifier(contractNumber, version, subVersion));

            // assert
            contractAllocationsContractAllocation allocation = masterContract.contracts.First().contractAllocations.First();
            Assert.AreEqual(stopNewStartsDate, allocation.StopNewStartsDate, "Allocation Stop New Starts Date was not returned");
            Assert.AreEqual(newStartsSuspendedReason, allocation.NewStartsSuspendedReason, "Allocation New Starts Suspended Reason was not returned");
            Assert.AreEqual(fundingCessationDate, allocation.FundingCessationDate, "Allocation Funding Cessation Date was not returned");
        }

        private static void DeleteContract(string contractNumber)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(connection))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_contractId.Value)
                    .ForEach(id => connection.Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private static void DeleteAllocation(string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractallocationSet
                    .Where(a => a.sfa_contractallocationnumber == allocationNumber)
                    .Select(a => a.sfa_contractallocationId.Value)
                    .ForEach(id => organizationService.Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private static EntityReference GetPeriod()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_periodSet.First(p => p.sfa_periodname == "FY2021").ToEntityReference();
            }
        }

        private static Guid CreateContract(
            string contractNumber,
            int version,
            int subVersion, 
            sfa_contractstatus status,
            string subStatus,
            Guid masterContractId,
            DateTime? terminationDate = null, 
            sfa_TerminationReasons? terminationReason = null)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1",
                sfa_terminationdate = terminationDate,
                sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                sfa_PeriodId = GetPeriod(),
                sfa_FundingType = GetFundingType(),
                sfa_terminationreason = terminationReason != null ? new OptionSetValue((int)terminationReason) : null
            };

            Guid contractId = connection.Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int)status);
            contract.sfa_SubStatus = GetSubStatusEntityReference(subStatus);
            contract.EntityState = EntityState.Changed;
            connection.Update(contract);

            return contractId;
        }

        private static Guid CreateMasterContract(string contractNumber, int version, int subVersion)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_FundingType = GetFundingType(),
                sfa_UKPRN = "1",
                sfa_ContractValue = new Money()
            };

            Guid contractId = connection.Create(contract);

            contract.Id = contractId;
            
            contract.EntityState = EntityState.Changed;
            connection.Update(contract);

            return contractId;
        }

        private static void CreateAllocation(
            Guid contractId, string allocationNumber, DateTime stopNewStartsDate, string newStartsSuspendedReason, DateTime fundingCessationDate)
        {
            IOrganizationService connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_newstartssuspendedreason newStartsSuspendedReasonEnum =
                (sfa_newstartssuspendedreason)Enum.Parse(typeof(sfa_newstartssuspendedreason), newStartsSuspendedReason.Replace(" ", string.Empty));

            var allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference("sfa_contract", contractId),
                sfa_FundingStreamId = GetFirstFundingStreamEntityReference(),
                sfa_FundingStreamPeriodId = GetFirstFundingStreamPeriodEntityReference(),
                sfa_stopnewstartsdate = stopNewStartsDate,
                sfa_newstartssuspendedreason = new OptionSetValue(Convert.ToInt32(newStartsSuspendedReasonEnum)),
                sfa_terminationdate = fundingCessationDate
            };

            connection.Create(allocation);
        }

        private static EntityReference GetSubStatusEntityReference(string subStatus)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private static EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private static EntityReference GetFundingType()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingtypeSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetFirstFundingStreamEntityReference()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingstreamSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetFirstFundingStreamPeriodEntityReference()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First().ToEntityReference();
            }
        }
    }

    public static class DateTimeExtensions
    {
        public static bool IsDateTimeEqualTo(this DateTime actual, DateTime expected)
        {
            return ((expected.Year == actual.Year)
                    && (expected.Month == actual.Month)
                    && (expected.Day == actual.Day)
                    && (expected.Hour == actual.Hour)
                    && (expected.Minute == actual.Minute)
                    && (expected.Second == actual.Second));
        }
    }
}
