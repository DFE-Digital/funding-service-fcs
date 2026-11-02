namespace ContractManagementDomain.Termination.Xrm.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private const string MasterContractNumber = "MCIT-1";
        private const string ContractNumber = "NED-1";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldSetNullContractEndDateToEqualTerminationDate()
        {
            // arrange
            DateTime expectedDate = new DateTime(2018, 1, 1);

            ClearDownContractsAndAllocations();

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            Guid contractId = CreateContractWithNullEndDateAndNotNullTerminationDate(terminationDate: expectedDate);

            // act
            repository.OverwriteNullEndDateWithTerminationDate(ContractNumber, 1 , 0);

            // assert
            DateTime? endDate = GetContractEndDate(contractId);

            Assert.AreEqual(expectedDate, endDate, "Contract End Date was not set to the termination date");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldSetNullContractAllocationEndDatesToEqualAllocationTerminationDate()
        {
            // arrange
            DateTime expectedDate = new DateTime(2018, 1, 1);

            ClearDownContractsAndAllocations();

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            Guid contractId = CreateContractWithNullEndDateAndNotNullTerminationDate(terminationDate: expectedDate);
            Guid allocId = CreateAllocationWithNullEndDateAndNotNullTerminationDateForContract(contractId: contractId, terminationDate: expectedDate);

            // act
            repository.OverwriteNullAllocationEndDatesWithTerminationDates(ContractNumber, 1, 0);

            // assert
            DateTime? endDate = GetAllocationEndDate(allocId);

            Assert.AreEqual(expectedDate, endDate, "Allocation end date was not set to the termination date");
        }

        private Guid CreateContractWithNullEndDateAndNotNullTerminationDate(DateTime terminationDate)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_number = ContractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ProviderName = GetProvider(organizationSvc),
                sfa_UKPRN = "1",
                sfa_terminationdate = terminationDate,
                sfa_EndDate = null
            };

            Guid contractId = organizationSvc.Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            contract.sfa_SubStatus = GetSubStatusEntityReference("Approved", organizationSvc);
            contract.EntityState = EntityState.Changed;
            organizationSvc.Update(contract);

            return contractId;
        }

        private Guid CreateAllocationWithNullEndDateAndNotNullTerminationDateForContract(Guid contractId, DateTime terminationDate)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = $"A{ContractNumber}",
                sfa_enddate = null,
                sfa_terminationdate = terminationDate
            };

            return organizationSvc.Create(allocation);
        }

        private static EntityReference GetSubStatusEntityReference(string subStatus, IOrganizationService orgService)
        {
            using (var context = new XrmServiceContext(orgService))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private static EntityReference GetProvider(IOrganizationService orgService)
        {
            using (var xrmContext = new XrmServiceContext(orgService))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private void ClearDownContractsAndAllocations()
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                List<Guid> masterContracts = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == MasterContractNumber)
                    .Select(c => c.sfa_contractId.Value).ToList();

                List<Guid> childContracts = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == ContractNumber)
                    .Select(c => c.sfa_contractId.Value).ToList();

                List<Guid> allocations = new List<Guid>();

                childContracts.ForEach(childContract => 
                    allocations.AddRange(
                        from c in xrmContext.sfa_contractSet
                        join a in xrmContext.sfa_contractallocationSet
                            on c.sfa_contractId equals a.sfa_ContractId.Id
                        where c.sfa_contractId == childContract
                        select a.sfa_contractallocationId.Value));

                allocations.ForEach(a => organizationSvc.Delete(sfa_contractallocation.EntityLogicalName, a));
                childContracts.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
                masterContracts.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private DateTime? GetAllocationEndDate(Guid allocationId)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                return (from a in xrmContext.sfa_contractallocationSet
                    where a.sfa_contractallocationId == allocationId
                    select a.sfa_enddate).SingleOrDefault();
            }
        }

        private DateTime? GetContractEndDate(Guid contractId)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                return (from c in xrmContext.sfa_contractSet
                    where c.sfa_contractId == contractId
                    select c.sfa_EndDate).SingleOrDefault();
            }
        }
    }
}
