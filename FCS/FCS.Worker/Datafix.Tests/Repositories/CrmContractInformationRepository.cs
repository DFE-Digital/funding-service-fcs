namespace Datafix.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class CrmContractInformationRepository : ICrmContractInformationRepository
    {
        public IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(
            string fundingTypeCode, string fundingPeriodCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var contracts = (
                        from contract in context.sfa_contractSet
                        join master in context.sfa_contractSet on contract.sfa_ParentContractId.Id equals master.Id
                        join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                        join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType
                            .Id
                        join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                        where fundingType.sfa_fundingtypecode == fundingTypeCode
                              && period.sfa_periodname == fundingPeriodCode
                              && contract.sfa_HierarchyType.Value == (int) sfa_contracthierarchytype.Contract
                              && contract.sfa_LatestVersion == true
                        select new
                        {
                            Contract = contract, Substatus = sfaStatus.sfa_name, MasterNumber = master.sfa_number
                        }
                    )
                    .ToList();

                return contracts.Select(c => new ContractInformation(
                    c.Contract.sfa_number,
                    c.MasterNumber,
                    c.Contract.sfa_Version.Value,
                    c.Contract.sfa_SubVersion.Value,
                    c.Contract.sfa_UKPRN,
                    CrmToContractInformationStatusTransformer.TransformContractStatus(
                        (sfa_contractstatus) c.Contract.sfa_ContractStatus.Value),
                    CrmToContractInformationStatusTransformer.TransformContractSubStatus(c.Substatus))).ToList();
            }
        }

        public IReadOnlyCollection<ContractInfo> GetLastApprovedContracts()
        {
            int thirtyMinutes = 60 * 30;
            string connectionString =
                ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"SELECT sfa_number as contractNumber,
                                      sfa_version as version,
                                      sfa_subversion as subVersion,
                                      createdon
                              FROM [dbo].[sfa_contract]
                              where sfa_lastapprovedversion = 1";

                return connection.Query<ContractInfo>(sql, commandTimeout: thirtyMinutes).ToList();
            }
        }

        public ISet<ContractInfo> GetLastApprovedAndLatestVersionContractsWithoutDuplicates()
        {
            int thirtyMinutes = 60 * 30;
            string connectionString =
                ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"SELECT sfa_number as contractNumber,
                                      sfa_version as version,
                                      sfa_subversion as subVersion,
                                      createdon as createdDate,
                                      sfa_amendmenttype as amendmentTypeCrmEnum
                              FROM dbo.sfa_contract
                              where sfa_lastapprovedversion = 1 OR sfa_latestversion = 1";

                return connection.Query<ContractInfo>(sql, commandTimeout: thirtyMinutes).ToHashSet();
            }
        }

        public IReadOnlyCollection<ApprovedContract> GetReplacedContracts()
        {
            int thirtyMinutes = 60 * 30;

            string connectionString =
                ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"SELECT c.sfa_number as contractNumber,
                                      c.sfa_version as contractVersionNumber,
                                      c.sfa_subversion as contractSubVersionNumber,
									  ft.sfa_fundingtypecode as fundingType,
									  fp.sfa_periodname as fundingPeriod,
                                      c.sfa_ukprn as ukprn,
									  a.sfa_organisationid as organisationId,
									  m.sfa_number as masterContractNumber,
									  c.sfa_startdate as startDate,
									  c.sfa_enddate as endDate
                              FROM dbo.sfa_contract c,
							      [dbo].[sfa_fundingtype] ft,
								  [dbo].[sfa_period] fp,
								  [dbo].[account] a,
								  dbo.sfa_contract m
                              where c.sfa_contractstatus = @contractStatus
							  and c.sfa_fundingtype = ft.Id
							  and c.sfa_periodid = fp.Id
							  and c.sfa_providername = a.id
							  and c.sfa_parentcontractid = m.Id";

                return connection.Query<ApprovedContract>(sql, commandTimeout: thirtyMinutes,
                    param: new {contractStatus = sfa_contractstatus.Replaced}).ToList();
            }
        }

        public static IReadOnlyCollection<CrmContractTerminationInfo> GetContractTerminationInfos(string subStatusName,
            sfa_contractstatus contractStatus)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var contracts = (
                        from contract in context.sfa_contractSet
                        join allocation in context.sfa_contractallocationSet on contract.Id equals allocation
                            .sfa_ContractId.Id
                        join subStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals subStatus.Id
                        where contract.sfa_HierarchyType.Value == (int) sfa_contracthierarchytype.Contract
                              && subStatus.sfa_name == subStatusName
                              && contract.sfa_ContractStatus.Value == (int) contractStatus
                              && contract.sfa_terminationdate != null
                        select new
                        {
                            ContractId = contract.Id,
                            ContractTerminationDate = contract.sfa_terminationdate,
                            ContractTerminationReason = contract.sfa_terminationreason,
                            AllocationId = allocation.sfa_contractallocationId.Value,
                            AllocationTerminationDate = allocation.sfa_terminationdate,
                            AllocationStopNewStartDate = allocation.sfa_stopnewstartsdate
                        }
                    )
                    .ToList();

                return contracts
                    .GroupBy(c => new
                    {
                        c.ContractId, c.ContractTerminationDate, c.ContractTerminationReason
                    })
                    .Select(allocationGrp => new CrmContractTerminationInfo(
                        contractId: allocationGrp.Key.ContractId,
                        terminationDate: allocationGrp.Key.ContractTerminationDate,
                        terminationReason: allocationGrp.Key.ContractTerminationReason,
                        allocations: allocationGrp.Select(a => new CrmAllocationTerminationInfo(
                            allocationId: a.AllocationId,
                            terminationDate: a.AllocationTerminationDate,
                            stopNewStartsDate: a.AllocationStopNewStartDate)).ToList())
                    ).ToList();
            }
        }

        public static IReadOnlyCollection<Guid> GetContractIdsWithAnEmptyContractTypeForFundingType(
            string fundingTypeCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var contractIds = (
                        from contract in context.sfa_contractSet
                        join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType
                            .Id

                        where fundingType.sfa_fundingtypecode == fundingTypeCode
                              && contract.sfa_HierarchyType.Value == (int) sfa_contracthierarchytype.Contract
                              && contract.sfa_ContractType == null

                        select contract.sfa_contractId.Value)
                    .ToList();

                return contractIds.ToList();
            }
        }

        public static CrmAllocationInfo GetAllocationInfo(string contractNumber, int version, int subVersion, string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var deliverables = (
                        from contract in context.sfa_contractSet
                        join alloc in context.sfa_contractallocationSet on contract.sfa_contractId.Value equals alloc
                            .sfa_ContractId.Id
                        join d in context.sfa_contractdeliverableSet on alloc.sfa_contractallocationId.Value equals d.sfa_ContractAllocationId.Id
                        where contract.sfa_number == contractNumber &&
                              contract.sfa_Version == version &&
                              contract.sfa_SubVersion == subVersion &&
                              alloc.sfa_contractallocationnumber == allocationNumber

                        select new {Allocationid = alloc.sfa_contractallocationId.Value, DeliverableId = d.sfa_contractdeliverableId.Value, d.sfa_DeliverableCode})
                    .ToList();

                return deliverables.GroupBy(d => d.Allocationid)
                    .Select(grp => new CrmAllocationInfo(
                        grp.Key, 
                        grp.Select(d => new CrmDeliverableInfo(d.DeliverableId, deliverableCode:int.Parse(d.sfa_DeliverableCode))).ToList()))
                    .Single();
            }
        }

        public static IReadOnlyCollection<ContractIdentifier> GetLastApprovedContractInformationByStatusAndSubStatus(
            sfa_contractstatus status, string subStatus)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var contracts = (
                        from contract in context.sfa_contractSet
                        join s in context.sfa_statusSet on contract.sfa_SubStatus.Id equals s.sfa_statusId.Value
                        where contract.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                        && contract.sfa_LastApprovedVersion == true
                        && contract.sfa_ContractStatus.Value == (int)status
                        && s.sfa_name == subStatus
                        select new
                        {
                            Number = contract.sfa_number,
                            Version = contract.sfa_Version.Value,
                            SubVersion = contract.sfa_SubVersion.Value
                        }
                    )
                    .ToList();

                return contracts.Select(c => new ContractIdentifier(
                    c.Number, c.Version, c.SubVersion)).ToList();
            }
        }
    }
}
