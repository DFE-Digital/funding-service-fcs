namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using DTO;
    using DTO.ContractTermination;
    using Extensions;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Services;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using sfa_contract = CrossDomain.Integration.Entities.Xrm.sfa_contract;

    public static class CrmContractRepository
    {
        public static ContractDetail GetLatestContractDetail(string contractNumber, int versionNumber)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                ContractDetail contractDetail = (
                    from c in context.sfa_contractSet
                    join o in context.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
                    join ft in context.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.sfa_fundingtypeId
                    join p in context.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                    join pt in context.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                    where c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_LatestVersion == true
                    select new ContractDetail
                    {
                        Id = c.Id,
                        ContractNumber = c.sfa_number,
                        VersionNumber = c.sfa_Version.GetValueOrDefault(),
                        SubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                        TerminationDate = c.sfa_terminationdate,
                        TerminationReason = c.sfa_terminationreasonEnum.ToString(),
                        ContractApprovalDate = c.sfa_ContractApprovalDate,
                        FundingTypeCode = ft.sfa_fundingtypecode,
                        FundingTypeName = ft.sfa_name,
                        PeriodTypeCode = pt.sfa_periodtypecode,
                        PeriodTypeName = pt.sfa_PeriodTypeName,
                        Period = p.sfa_Period,
                        OrganisationId = o.sfa_OrganisationID,
                        Ukprn = int.Parse(o.sfa_UKPRN),
                        ContractType = c.sfa_ContractType != null ? c.sfa_ContractType.Name : string.Empty,
                        StartDate = c.sfa_StartDate.GetValueOrDefault(),
                        EndDate = c.sfa_EndDate,
                        Status = Enum.GetName(typeof(sfa_contractstatus), c.sfa_ContractStatus.Value),
                        SubStatus = c.sfa_SubStatus.Name,
                        ContractValue = c.sfa_ContractValue != null ? c.sfa_ContractValue.Value : 0,
                        AmendmentType = c.sfa_AmendmentTypeEnum != null ? c.sfa_AmendmentTypeEnum.ToString() : null,
                    }).Single();

                contractDetail.Allocations = (
                    from a in context.sfa_contractallocationSet
                    join fs in context.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals fs.sfa_fundingstreamId
                    join fsp in context.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    where a.sfa_ContractId.Id == contractDetail.Id
                    select new AllocationDetail
                    {
                        Id = a.Id,
                        AllocationNumber = a.sfa_contractallocationnumber,
                        FundingStreamCode = fs.sfa_fundingstreamcode,
                        FundingStreamName = fs.sfa_fundingstreamname,
                        FundingTypeCode = contractDetail.FundingTypeCode,
                        FundingStreamPeriodCode = fsp.sfa_fundingstreamperiodcode,
                        StartDate = a.sfa_startdate.GetValueOrDefault(),
                        EndDate = a.sfa_enddate,
                        MaximumContractValue = a.sfa_maximumcontractvalue.GetValueOrDefault(),
                        FundingCessationDate = a.sfa_terminationdate,
                        NewStartsSuspendedReason = a.sfa_newstartssuspendedreason != null ?
                            ((sfa_newstartssuspendedreason)a.sfa_newstartssuspendedreason.Value).ToUserReadableString() : null,
                        StopNewStartsDate = a.sfa_stopnewstartsdate
                    }).ToList();

                return contractDetail;
            }
        }

        public static sfa_contract GetLatestContract(string ukprn, string fundingType, string period, sfa_contracthierarchytype hierarchyType)
        {
            IEnumerable<sfa_contract> matchingContracts = null;
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                matchingContracts = (from c in xrmContext.sfa_contractSet
                                     join p in xrmContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                                     join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.sfa_fundingtypeId
                                     where c.sfa_UKPRN == ukprn
                                           && p.sfa_Period == period
                                           && ft.sfa_fundingtypecode == fundingType
                                           && c.sfa_HierarchyType.Value == (int)hierarchyType
                                     select c).AsEnumerable();
            }

            return matchingContracts.OrderByDescending(c => c.CreatedOn).FirstOrDefault();
        }

        public static sfa_contract GetContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet.First(c => c.sfa_contractId == contractId);
            }
        }

        public static Guid GetContractIdForNumber(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_LatestVersion == true)
                    .Select(c => c.sfa_contractId.Value).Single();
            }
        }

        public static sfa_contract GetContract(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return
                    xrmContext.sfa_contractSet.SingleOrDefault(
                        c =>
                            c.sfa_number == contractNumber &&
                            c.sfa_Version == versionNumber &&
                            c.sfa_SubVersion == subVersionNumber
                        );
            }
        }

        public static ContractDto GetLatestContractInfoByProviderAndDeliveryOrg(string ukprn, string period, string fundingType, string deliveryOrgUkprn)
        {
            ContractDto latestContract = null;
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IEnumerable<ContractDto> matchingContracts = (from c in xrmContext.sfa_contractSet
                                     join p in xrmContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                                     join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                                     join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.sfa_fundingtypeId
                                     join ca in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals ca.sfa_ContractId.Id
                                     join org in xrmContext.AccountSet on c.sfa_ProviderName.Id equals org.AccountId
                                     where c.sfa_UKPRN == ukprn
                                           && p.sfa_Period == period
                                           && ft.sfa_fundingtypecode == fundingType
                                           && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                                           && ca.sfa_deliveryorganisationukprn == deliveryOrgUkprn
                                     select new ContractDto
                                     {
                                         ContractId = c.Id,
                                         ContractNumber = c.sfa_number,
                                         MasterContractNumber = m.sfa_number,
                                         CreatedOn = c.CreatedOn.Value,
                                         Upin = org.sfa_orgupin,
                                         ContractVersion = c.sfa_Version.Value,
                                         Ukprn = ukprn
                                     }).AsEnumerable();

                latestContract = matchingContracts.OrderByDescending(c => c.CreatedOn).FirstOrDefault();

                var allocationNumberPrefixes = xrmContext.sfa_contractallocationSet.Where(allocation => allocation.sfa_ContractId.Id == latestContract.ContractId && allocation.sfa_deliveryorganisationukprn == deliveryOrgUkprn)
                    .Select(allocation=> new AllocationNumberPrefix(ExtractPrefixFromContractAllocationNumber(allocation.sfa_contractallocationnumber), 
                                                             allocation.sfa_contractallocationnumber));
                latestContract.AllocationNumberPrefixes = allocationNumberPrefixes.ToList();
            }

            return latestContract;
        }

        private static string ExtractPrefixFromContractAllocationNumber(string contractAllocationNumber)
        {
            int indexOfHyphen = contractAllocationNumber
                        .IndexOf("-", StringComparison.Ordinal);

            return contractAllocationNumber.Substring(0, indexOfHyphen);
        }

        public static ContractDto GetLatestContractInfoByProvider(string ukprn, string period, string fundingType)
        {
            IEnumerable<ContractDto> matchingContracts = null;
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                matchingContracts = (from c in xrmContext.sfa_contractSet
                                     join p in xrmContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                                     join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                                     join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.sfa_fundingtypeId
                                     join org in xrmContext.AccountSet on c.sfa_ProviderName.Id equals org.AccountId
                                     where c.sfa_UKPRN == ukprn
                                           && p.sfa_Period == period
                                           && ft.sfa_fundingtypecode == fundingType
                                           && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                                     select new ContractDto
                                     {
                                         ContractId = c.Id,
                                         ContractNumber = c.sfa_number,
                                         MasterContractNumber = m.sfa_number,
                                         CreatedOn = c.CreatedOn.Value,
                                         Upin = org.sfa_orgupin,
                                         ContractVersion = c.sfa_Version.Value,
                                         Ukprn = ukprn
                                     }).AsEnumerable();
            }

            return matchingContracts.OrderByDescending(c => c.CreatedOn).FirstOrDefault();
        }

        public static void SetContractStatusAndSubStatus(string contractNumber, int versionNumber, string status, string subStatus)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber).Id;

                Guid subStatusId = context.sfa_statusSet.Single(s => s.sfa_name == subStatus).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatusEnum = (sfa_contractstatus)Enum.Parse(typeof(sfa_contractstatus), status),
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatusId)
                });
            }
        }

        public static void SetSubStatusForLatestContractWithVersion(string contractNumber, int versionNumber, string subStatus, string userName)
        {
            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(userName)))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber)
                    .OrderByDescending(c => c.sfa_SubVersion)
                    .First().Id;

                Guid subStatusId = context.sfa_statusSet.Single(s => s.sfa_name == subStatus).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatusId)
                });
            }
        }

        public static void SetSubStatusForContract(Guid contractId, string subStatus)
        {
            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetNonRetryingConnection()))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid subStatusId = context.sfa_statusSet.Single(s => s.sfa_name == subStatus).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatusId)
                });
            }
        }

        public static IReadOnlyCollection<sfa_contractallocation> GetAllocationsForContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from ca in xrmContext.sfa_contractallocationSet
                    where ca.sfa_ContractId.Id == contractId
                    select ca).ToList();
            }
        }

        public static int GetAllocationCountForContract(Guid contractId)
        {
            return GetAllocationsForContract(contractId).Count;
        }

        public static int GetDeliverableCountForContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from d in xrmContext.sfa_contractdeliverableSet
                        join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId
                        where a.sfa_ContractId.Id == contractId
                        select d)
                    .ToList().Count;
            }
        }

        public static int GetDeliverablePeriodCountForContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from dp in xrmContext.sfa_contractdeliverableperiodSet
                        join d in xrmContext.sfa_contractdeliverableSet on dp.sfa_ContractDeliverableId.Id equals d.sfa_contractdeliverableId
                        join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId 
                        where a.sfa_ContractId.Id == contractId
                        select dp)
                    .ToList().Count;
            }
        }

        public static Account GetAccountForContract(Guid id)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (xrmContext.AccountSet.First(account => account.Id == id));
            }
        }

        public static bool IsExistingMasterContract(string contractNumber)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && (sfa_contracthierarchytype)c.sfa_HierarchyType.Value == sfa_contracthierarchytype.Master)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .Any();
            }
        }

        public static bool IsExistingContract(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .Any();
            }
        }

        public static int GetCountOfCrmTasksForContractId(Guid crmContractId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.TaskSet.Where(t => t.RegardingObjectId.Id == crmContractId).ToList().Count;
            }
        }

        public static int GetCountOfWorkflowHistoryForContractId(Guid crmContractId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_contracttransitionhistorySet
                    .Where(wfh => wfh.sfa_Contract.Id == crmContractId)
                    .ToList().Count;
            }
        }

        public static void SetTransitionOnContract(Guid crmContractId, Guid transitionId, string userName)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = crmContractId,
                sfa_NextAction = new EntityReference(sfa_transition.EntityLogicalName, transitionId)

            };

            CrmConnectionFactory.GetConnectionForSpecificUser(userName)
                .Update(contract);
        }

        public static IReadOnlyCollection<TaskInfo> GetTasksForContract(string contractNumber, int version)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from t in xrmContext.TaskSet
                    join c in xrmContext.sfa_contractSet on t.RegardingObjectId.Id equals c.Id
                    where c.sfa_number == contractNumber
                        && c.sfa_Version == version
                    select new TaskInfo
                    {
                        Id = t.Id,
                        Name = t.Subject,
                        Description = t.Description,
                        AssignedTeam = GetTeamNameForId(t.sfa_AssignedTeam),
                        Owner = GetOwnerNameForId(t.OwnerId),
                        State = Enum.GetName(typeof (TaskState), t.StateCode.Value),
                        Status = Enum.GetName(typeof (task_statuscode), t.StatusCode.Value)
                    }).ToList();
            }
        }

        public static void SetTaskOwnerOnContract(Guid contractId, Guid userId)
        {
            AssignRequest assignRequest = new AssignRequest
            {
                Assignee = new EntityReference(SystemUser.EntityLogicalName,userId),

                Target = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            CrmConnectionFactory.GetConnection().Execute(assignRequest);
        }

        public static void SetNextActionWithReasonForRejection(string actionName, string contractNumber, int version, string userName, string reasonText)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = GetMostRecentByContractId(contractNumber, version),
                sfa_NextAction = GetActionWithNameEntityReference(actionName),
                sfa_ReasonForRejection = reasonText
            };
                   
            CrmConnectionFactory.GetConnectionForSpecificUser(userName).Update(contract);
        }

        public static Guid GetMostRecentByContractId(string contractNumber, int version)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version)
                    .Select(c => new {c.Id, c.CreatedOn})
                    .AsEnumerable()
                    .OrderByDescending(c => c.CreatedOn)
                    .First().Id;
            }
        }

        public static Guid GetContractId(string contractNumber, int version, int subVersion)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .Single();
            }
        }

        public static Guid GetContractIdIfPresent(string contractNumber, int version, int subVersion)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .SingleOrDefault();
            }
        }

        public static IReadOnlyCollection<Guid> GetContractsForNumber(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList();
            }
        }

        public static void SetAmendmentInProgressIndicator(string contractNumber, int versionNumber, int subVersionNumber, bool isAmendmentInProgress)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = GetContractId(contractNumber, versionNumber, subVersionNumber),
                sfa_nfainprogress = isAmendmentInProgress
            };

            CrmConnectionFactory.GetConnection().Update(contract);
        }

        public static bool IsAmendmentInProgressForContract(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_contractSet
                    .Where(
                        c =>
                            c.sfa_number == contractNumber && c.sfa_Version == versionNumber &&
                            c.sfa_SubVersion == subVersionNumber)
                    .Select(c => c.sfa_nfainprogress)
                    .Single() ?? false; // if sfa_nfainprogress is null, return false, but if contract is not found throw exception
            }
        }

        private static EntityReference GetActionWithNameEntityReference(string actionName)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_transitionSet
                    .Single(t => t.sfa_name == actionName)
                    .ToEntityReference();
            }
        }

        private static string GetTeamNameForId(EntityReference team)
        {
            if (team != null)
            {
                using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
                {
                    return context.TeamSet.SingleOrDefault(t => t.Id == team.Id)?.Name;
                }
            }

            return string.Empty;
        }

        public static ContractTerminationValues GetContractTerminationValues(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber)
                    .Select(c => new ContractTerminationValues
                    {
                        ContractNumber = c.sfa_number,
                        VersionNumber = c.sfa_Version.Value,
                        SubVersionNumber = c.sfa_SubVersion.Value,
                        TerminationDate = c.sfa_terminationdate,
                        InitiateAmendmentOnApproval = c.sfa_initiateamendment,
                        TerminationReason = c.sfa_terminationreason != null ? Enum.GetName(typeof(sfa_TerminationReasons), c.sfa_terminationreason.Value) : null,
                        TerminationComments = c.sfa_terminationcomments,
                        ProvisionalTerminationDate = c.sfa_inflightterminationdate,
                        ProvisionalTerminationReason = c.sfa_inflightterminationreason != null ? Enum.GetName(typeof(sfa_TerminationReasons), c.sfa_inflightterminationreason.Value) : null,
                        ProvisionalTerminationComments = c.sfa_inflightterminationcomments,
                        DefaultStopNewStartsDate = c.sfa_defaultstopnewstartsdate,
                        ProvisionalStopNewStartsDate = c.sfa_inflightstopnewstartsdate,
                        DefaultNewStartsSuspendedReason = c.sfa_defaultnewstartssuspendedreason != null ? Enum.GetName(typeof(sfa_newstartssuspendedreason), c.sfa_defaultnewstartssuspendedreason.Value) : null,
                        ProvisionalNewStartsSuspendedReason = c.sfa_inflightnewstartssuspendedreason != null ? Enum.GetName(typeof(sfa_newstartssuspendedreason), c.sfa_inflightnewstartssuspendedreason.Value) : null
                    })
                    .Single();
            }
        }

        public static string GetContractType(Guid contactTypeId)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_contracttypeSet.Single(ct => ct.sfa_contracttypeId == contactTypeId).sfa_name;
            }
        }

        public static IReadOnlyCollection<ContractId> GetContractIdsForFsp(string fspCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var contracts = (from c in context.sfa_contractSet
                    join a in context.sfa_contractallocationSet on c.Id equals a.sfa_ContractId.Id
                    join fsp in context.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.Id
                    join m in context.sfa_contractSet on c.sfa_ParentContractId.Id equals m.Id
                                 where fsp.sfa_fundingstreamperiodcode == fspCode
                          && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                    select new {c.Id, MasterId = c.sfa_ParentContractId.Id, c.sfa_number, c.sfa_Version, MasterNumber = m.sfa_number, OrgId = c.sfa_ProviderName.Id}).ToList().Distinct();

                return contracts.Select(c => new ContractId(c.Id, c.MasterId, c.sfa_number, c.sfa_Version ?? 0, c.MasterNumber, c.OrgId)).ToList();
            }
        }

        public static IReadOnlyCollection<ContractId> GetContractIdsRelatingToMaster(string masterContractNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var contracts = (from c in context.sfa_contractSet
                    join m in context.sfa_contractSet on c.sfa_ParentContractId.Id equals m.Id
                    where  c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                           && m.sfa_number == masterContractNumber
                    select new { c.Id, MasterId = c.sfa_ParentContractId.Id, c.sfa_number, c.sfa_Version, MasterNumber = m.sfa_number }).ToList().Distinct();

                return contracts.Select(c => new ContractId(c.Id, c.MasterId, c.sfa_number, c.sfa_Version ?? 0, c.MasterNumber, Guid.Empty)).ToList();
            }
        }

        public static void ClearAll()
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract)
                    .Select(c => c.sfa_contractId.Value)
                    .ToList()
                    .ForEach(id =>
                    {
                        try
                        {
                            DeleteContract(id);
                            CrmReplicatedRepository.DeleteContract(id);
                        }
                        catch
                        {

                        }
                        
                    });
                
            }
        }

        public static void DeleteContract(Guid contractId)
        {
            CrmConnectionFactory.GetConnection().Delete(sfa_contract.EntityLogicalName, contractId);
            CrmReplicatedRepository.DeleteContract(contractId);
        }

        public static void DeleteContractsForOrganisation(Guid orgId)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_ProviderName != null && c.sfa_ProviderName.Id == orgId)
                    .Select(c => new {Id = c.sfa_contractId.Value, c.sfa_HierarchyType})
                    .ToList()
                    .OrderBy(c => c.sfa_HierarchyType?.Value)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(DeleteContract);
            }
        }

        public static Guid GetContractForMaster(Guid masterId)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_contractSet.Where(c => c.sfa_ParentContractId.Id == masterId)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .First();
            }
        }

        /// <summary>
        /// An owner is either a User or a Team
        /// </summary>
        /// <param name="owner">The pk for a user or a team...good old crm</param>
        /// <returns>An owner is either a User or a Team</returns>
        private static string GetOwnerNameForId(EntityReference owner)
        {
            if (owner == null)
            {
                return string.Empty;
            }

            string ownerName = null;
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                ownerName = context.SystemUserSet.SingleOrDefault(t => t.Id == owner.Id)?.FullName;
            }

            return ownerName ?? GetTeamNameForId(owner);
        }

        public static void InsertTerminationValuesAsUser(Guid contractId, ContractTerminationRequest contractTerminationRequest)
        {
            sfa_TerminationReasons terminationReasonEnum =
                (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), contractTerminationRequest.TerminationReason.Replace(" ", string.Empty));

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(contractTerminationRequest.User)))
            {
                sfa_contract contract = new sfa_contract
                {
                    Id = contractId,
                    sfa_defaultstopnewstartsdate = contractTerminationRequest.DefaultStopNewStartsDate,
                    sfa_terminationdate = contractTerminationRequest.ContractTerminationDate,
                    sfa_terminationreason = new OptionSetValue(Convert.ToInt32(terminationReasonEnum)),
                    sfa_terminationreasonEnum = terminationReasonEnum,
                    sfa_initiateamendment = contractTerminationRequest.InitiateAmendmentOnApproval,
                    sfa_terminationcomments = contractTerminationRequest.TerminationComments,
                    sfa_inflightterminationdate = contractTerminationRequest.ProvisionalTerminationDate
                };

                if (contractTerminationRequest.ProvisionalTerminationReason != null)
                {
                    sfa_TerminationReasons provisionalTerminationReasonEnum =
                        (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), contractTerminationRequest.ProvisionalTerminationReason.Replace(" ", string.Empty));
                    contract.sfa_inflightterminationreason = new OptionSetValue(Convert.ToInt32(provisionalTerminationReasonEnum));
                }

                organizationService.Update(contract);

                contractTerminationRequest.Allocations.ForEach(contractAllocation =>
                {
                    Guid contractAllocationId = GetContractAllocationId(
                        contractAllocation.AllocationNumber, contractTerminationRequest.Version, contractTerminationRequest.SubVersion);

                    organizationService.Update(new sfa_contractallocation
                    {
                        Id = contractAllocationId,
                        sfa_stopnewstartsdate = contractAllocation.AllocationStopNewStartsDate,
                        sfa_terminationdate = contractAllocation.AllocationTerminationDate,
                        sfa_inflightstopnewstartsdate = contractAllocation.ProvisionalStopNewStartsDate,
                        sfa_inflightterminationdate  = contractAllocation.ProvisionalFundingCessationDate
                    });
                });
            }
        }

        public static void UpdateTerminationValuesAsUser(UpdateContractTerminationRequest updateContractTerminationRequest)
        {
            Guid contractId = GetContractId(
                updateContractTerminationRequest.ContractNumber, updateContractTerminationRequest.Version, updateContractTerminationRequest.SubVersion);

            EntityReference nextAction = GetActionWithNameEntityReference("Update Termination Details");

            sfa_TerminationReasons terminationReasonEnum =
                (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), updateContractTerminationRequest.TerminationReason.Replace(" ", string.Empty));

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(updateContractTerminationRequest.User)))
            {
                updateContractTerminationRequest.Allocations.ForEach(contractAllocation =>
                {
                    Guid contractAllocationId = GetContractAllocationId(
                        contractAllocation.AllocationNumber, updateContractTerminationRequest.Version, updateContractTerminationRequest.SubVersion);

                    organizationService.Update(new sfa_contractallocation
                    {
                        Id = contractAllocationId,
                        sfa_stopnewstartsdate = contractAllocation.AllocationStopNewStartsDate,
                        sfa_terminationdate = contractAllocation.AllocationTerminationDate,
                        sfa_inflightstopnewstartsdate = contractAllocation.ProvisionalStopNewStartsDate,
                        sfa_inflightterminationdate = contractAllocation.ProvisionalTerminationDate
                    });
                });
                
                sfa_contract contract = new sfa_contract
                {
                    Id = contractId,
                    sfa_terminationdate = updateContractTerminationRequest.ContractTerminationDate,
                    sfa_terminationreason = new OptionSetValue(Convert.ToInt32(terminationReasonEnum)),
                    sfa_terminationreasonEnum = terminationReasonEnum,
                    sfa_terminationcomments = updateContractTerminationRequest.TerminationComments,
                    sfa_inflightterminationdate = updateContractTerminationRequest.ProvisionalTerminationDate,
                    sfa_inflightterminationcomments = updateContractTerminationRequest.ProvisionalTerminationComments,
                    sfa_NextAction = nextAction
                };

                if (updateContractTerminationRequest.ProvisionalTerminationReason != null)
                {
                    sfa_TerminationReasons provisionalTerminationReasonEnum =
                        (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), updateContractTerminationRequest.ProvisionalTerminationReason.Replace(" ", string.Empty));
                    contract.sfa_inflightterminationreason = new OptionSetValue(Convert.ToInt32(provisionalTerminationReasonEnum));
                }

                organizationService.Update(contract);
            }
        }

        public static void ModifyContractValuesAsUser(ModifyContractRequest modifyContractRequest)
        {
            Guid contractId = GetContractId(
                modifyContractRequest.ContractNumber, modifyContractRequest.Version, modifyContractRequest.SubVersion);

            EntityReference nextAction = GetActionWithNameEntityReference("Initiate Contract Modification");

            sfa_newstartssuspendedreason defaultNewStartsSuspendedReasonEnum =
                (sfa_newstartssuspendedreason)Enum.Parse(typeof(sfa_newstartssuspendedreason), modifyContractRequest.DefaultNewStartsSuspendedReason.Replace(" ", string.Empty));

            IReadOnlyCollection<Guid> contractAllocationIds = GetContractAllocationIds(contractId);

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(modifyContractRequest.User)))
            {
                contractAllocationIds.ToList().ForEach(contractAllocationId =>
                {
                    organizationService.Update(new sfa_contractallocation
                    {
                        Id = contractAllocationId,
                        sfa_stopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                        sfa_newstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                        sfa_inflightstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                        sfa_inflightnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum))
                    });
                });

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_defaultstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                    sfa_defaultnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                    sfa_inflightstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                    sfa_inflightnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                    sfa_terminationcomments = modifyContractRequest.Comments,
                    sfa_NextAction = nextAction
                });
            }
        }

        public static void UpdateModificationValuesAsUser(ModifyContractRequest modifyContractRequest)
        {
            Guid contractId = GetContractId(
                modifyContractRequest.ContractNumber, modifyContractRequest.Version, modifyContractRequest.SubVersion);

            EntityReference nextAction = GetActionWithNameEntityReference("Update Modification Details");

            sfa_newstartssuspendedreason defaultNewStartsSuspendedReasonEnum =
                (sfa_newstartssuspendedreason)Enum.Parse(typeof(sfa_newstartssuspendedreason), modifyContractRequest.DefaultNewStartsSuspendedReason.Replace(" ", string.Empty));

            IReadOnlyCollection<Guid> contractAllocationIds = GetContractAllocationIds(contractId);

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(modifyContractRequest.User)))
            {
                contractAllocationIds.ToList().ForEach(contractAllocationId =>
                {
                    organizationService.Update(new sfa_contractallocation
                    {
                        Id = contractAllocationId,
                        sfa_stopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                        sfa_newstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                        sfa_inflightstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                        sfa_inflightnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum))
                    });
                });

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_defaultstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                    sfa_defaultnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                    sfa_inflightstopnewstartsdate = modifyContractRequest.DefaultStopNewStartsDate,
                    sfa_inflightnewstartssuspendedreason = new OptionSetValue(Convert.ToInt32(defaultNewStartsSuspendedReasonEnum)),
                    sfa_terminationcomments = modifyContractRequest.Comments,
                    sfa_NextAction = nextAction
                });
            }
        }

        public static void CancelModificationAsUser(string user, string contractNumber, int version, int subVersion)
        {
            Guid contractId = GetContractId(contractNumber, version, subVersion);
            EntityReference nextAction = GetActionWithNameEntityReference("Cancel Modification");

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(user)))
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_NextAction = nextAction
                });
            }
        }

        public static void SetTerminationInitiationRejectionValuesAsUser(string user, string contractNumber, int versionNumber, int subVersionNumber, string rejectionReason)
        {
            Guid contractId = GetContractId(contractNumber, versionNumber, subVersionNumber);
            EntityReference nextAction = GetActionWithNameEntityReference("Reject Termination Initiation");

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(user)))
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_NextAction = nextAction,
                    sfa_ReasonForRejection = rejectionReason
                });
            }
        }

        public static void TerminateContractAsUser(string user, string contractNumber, int versionNumber, int subVersionNumber)
        {
            Guid contractId = GetContractId(contractNumber, versionNumber, subVersionNumber);
            EntityReference nextAction = GetActionWithNameEntityReference("Terminate Contract");

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(user)))
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_NextAction = nextAction
                });
            }
        }

        public static void CancelContractTerminationAsUser(string user, string contractNumber, int versionNumber, int subVersionNumber)
        {
            Guid contractId = GetContractId(contractNumber, versionNumber, subVersionNumber);
            EntityReference nextAction = GetActionWithNameEntityReference("Cancel Termination");

            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnectionForSpecificUser(user)))
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_NextAction = nextAction
                });
            }
        }

        public static void SetCurrentTask(Guid contractId, Guid taskId)
        {
            using (OrganizationService organizationService = new OrganizationService(CrmConnectionFactory.GetConnection()))
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_CurrentTask = new EntityReference(Task.EntityLogicalName, taskId)
                });
            }
        }

        private static Guid GetContractAllocationId(string allocationNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (
                    from ca in context.sfa_contractallocationSet
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                    where
                        ca.sfa_contractallocationnumber == allocationNumber &&
                        c.sfa_Version == versionNumber &&
                        c.sfa_SubVersion == subVersionNumber
                    select ca.Id).Single();
            }
        }

        private static IReadOnlyCollection<Guid> GetContractAllocationIds(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (
                    from ca in xrmContext.sfa_contractallocationSet
                    where ca.sfa_ContractId.Id == contractId
                    select ca.Id
                    ).ToList();
            }
        }
    }
}
