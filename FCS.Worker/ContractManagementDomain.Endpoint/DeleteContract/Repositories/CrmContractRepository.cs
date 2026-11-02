namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<CrmContractIdentity> GetContractIds(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber)
                    .Select(c => new CrmContractIdentity
                    {
                        ContractId = c.sfa_contractId.Value,
                        MasterContractId = c.sfa_ParentContractId != null ? c.sfa_ParentContractId.Id : Guid.Empty
                    }).ToList();
            }
        }

        public void DeleteContractsTasksAndWorkflows(IReadOnlyCollection<Guid> contractIds)
        {
            var requestToCreateRecords = new ExecuteTransactionRequest()
            {
                Requests = new OrganizationRequestCollection(),
                ReturnResponses = true
            };

            void AddEntityReferencesToTransactionRequest(EntityReference er)
            {
                DeleteRequest deleteRequest = new DeleteRequest {Target = er};
                requestToCreateRecords.Requests.Add(deleteRequest);
            }

            var taskEntityReferences = contractIds.SelectMany(GetTaskEntityReferences).ToList();
            taskEntityReferences.ForEach(AddEntityReferencesToTransactionRequest);

            var workFlowEntityReferences = contractIds.SelectMany(GetWorkflowEntityReferences).ToList();
            workFlowEntityReferences.ForEach(AddEntityReferencesToTransactionRequest);

            var contractEntityReferences = contractIds.Select(id => new EntityReference(sfa_contract.EntityLogicalName, id)).ToList();
            contractEntityReferences.ForEach(AddEntityReferencesToTransactionRequest);

            try
            {
                _organizationService.Execute(requestToCreateRecords);
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                throw new ArgumentException("We have not been able to delete the contract, task and or workflow - " + ex.Detail.Message);
            }
        }

        public bool AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(Guid masterContractId, IReadOnlyCollection<Guid> childContracts)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                List<Guid> childContractsRelatedToTheMaster =
                    xrmServiceContext.sfa_contractSet
                        .Where(c => c.sfa_ParentContractId.Id == masterContractId)
                        .Select(c => c.Id)
                        .ToList();

                return childContractsRelatedToTheMaster.All(childContracts.Contains);
            }
        }

        public Guid? GetLastApprovedContractId(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_LastApprovedVersion.Value)
                    .Select(c => c.sfa_contractId)
                    .SingleOrDefault();
            }
        }

        public void UpdateContractToLatestVersion(Guid contractId)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_LatestVersion = true
            };

            _organizationService.Update(contract);
        }

        public bool IsSingleContractWhichIsNotSupersededDraft(string contractNumber, int versionNumber)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                return context.sfa_contractSet
                           .Where(c => c.sfa_number == contractNumber
                                       && c.sfa_Version == versionNumber
                                       && (sfa_contractstatus)c.sfa_ContractStatus.Value != sfa_contractstatus.SupersededDraft).ToList().Count == 1;
            }
        }

        private IEnumerable<EntityReference> GetTaskEntityReferences(Guid contractGuid)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    xrmServiceContext.TaskSet.Where(t => t.RegardingObjectId.Id == contractGuid)
                        .Select(t => new EntityReference(Task.EntityLogicalName, t.Id))
                        .ToList();
            }
        }

        private IEnumerable<EntityReference> GetWorkflowEntityReferences(Guid contractId)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    xrmServiceContext.sfa_contracttransitionhistorySet.Where(cth => cth.sfa_Contract.Id == contractId)
                        .Select(cth => new EntityReference(sfa_contracttransitionhistory.EntityLogicalName, cth.sfa_contracttransitionhistoryId.Value))
                        .ToList();
            }
        }

        private class ContractIdWithDate
        {
            public ContractIdWithDate(Guid contractId, DateTime createDateTime)
            {
                ContractId = contractId;
                CreateDateTime = createDateTime;
            }

            public Guid ContractId { get; }

            public DateTime CreateDateTime { get; }
        }
    }
}