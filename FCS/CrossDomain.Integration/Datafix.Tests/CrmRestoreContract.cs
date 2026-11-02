namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Runtime.Serialization;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using UnitTests.Common;
    using MoreLinq;

    [TestClass]
    public class CrmRestoreContract
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmRestore_GetExistingContractParts()
        {
            const string contractNumber = "NCS-1044";
            const int version = 1;
            const int subVersion = 0;

            FullContract contract = GetFullContract(contractNumber, version, subVersion);

            DataContractSerializer serializer = new DataContractSerializer(typeof (FullContract));

            MemoryStream memoryStream = new MemoryStream();
            
            serializer.WriteObject(memoryStream, contract);

            String result = System.Text.Encoding.UTF8.GetString(memoryStream.ToArray(), 0, (int)memoryStream.Length);

            int i = 0;
        }

        [TestMethod, TestCategory("DataFix_R44")]
        public void CrmRestore_GetTotalContractFromFileAndWriteToCrm()
        {
            const string fileName = "R44.TotalContract_NCS-1044.xml";
            FullContract contract = TestResource.FromXmlUsingDataContract<FullContract>("Datafix.Tests", $"Resources.{fileName}");

            EntityReference lastWorkFlow = contract.ChildContract.sfa_LastWorkflowHistory;
            contract.ChildContract.sfa_LastWorkflowHistory = null;
            OptionSetValue hierarchyType = contract.ChildContract.sfa_HierarchyType;

            WriteTotalContractToCrm(contract);

            RemoveAnyNewlyCreatedWorkflows(contract.ChildContract.Id, contract.Workflows.Select(w => w.Id).ToList());

            SetContractProperties(contractId: contract.ChildContract.Id, hierarchyType: hierarchyType);
        }

        private static void SetContractProperties(Guid contractId, OptionSetValue hierarchyType)
        {
            new OrganizationService(GetCrmConnection()).Update(new sfa_contract
            {
                Id = contractId,
                sfa_HierarchyType = hierarchyType
            });
        }

        public static EntityReference GetSubStatus(string subStatusName)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_name == subStatusName).ToEntityReference();
            }
        }

        private static void RemoveAnyNewlyCreatedWorkflows(Guid contractId, IReadOnlyCollection<Guid> requiredWorkflowIds)
        {
            IList<sfa_contracttransitionhistory> allWorkFlows = GetWorkflows(contractId);

            List<Guid> workFlowIdsNewlyCreated = allWorkFlows.Where(a => !requiredWorkflowIds.Contains(a.Id)).Select(w => w.Id).ToList();
            var connection = new OrganizationService(GetCrmConnection());

            workFlowIdsNewlyCreated.ForEach(id => connection.Delete(sfa_contracttransitionhistory.EntityLogicalName, id));
        }

        private static void WriteTotalContractToCrm(FullContract contract)
        {
            sfa_contract masterContract = contract.GetRelatedMasterContract();
            new OrganizationService(GetCrmConnection()).Update(masterContract);
        }

        private FullContract GetFullContract(string contractNumber, int version, int subVersion)
        {
            sfa_contract childContract = GetContract(contractNumber, version, subVersion);

            IList<sfa_contracttransitionhistory> workflows = GetWorkflows(childContract.Id);

            sfa_contract masterContract = GetContract(childContract.sfa_ParentContractId.Id);

            IList<sfa_contractallocation> allocations = GetAllocationsForContract(childContract.Id);
            IList<FullAllocation> fullAllocations = allocations.Select(a => new FullAllocation
            {
                Allocation = a,
                Deliverables = GetFullDeliverables(a.Id)
            }).ToList();

            return new FullContract {
                ChildContract = childContract,
                MasterContract = masterContract,
                Allocations = fullAllocations,
                Workflows = workflows
            };
        }

        private static IList<sfa_contracttransitionhistory> GetWorkflows(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return xrmContext.sfa_contracttransitionhistorySet.Where(ch => ch.sfa_Contract.Id == contractId).ToList();
            }
        }

        private IList<FullDeliverable> GetFullDeliverables(Guid allocationId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                var deliverables =  xrmContext.sfa_contractdeliverableSet.Where(d => d.sfa_ContractAllocationId.Id == allocationId).ToList();

                return deliverables.Select(d => new FullDeliverable
                {
                    Deliverable = d,
                    DeliverablePeriods = GetContractDeliverablePeriods(d.Id)
                }).ToList();
            }
        }

        private static IList<sfa_contractdeliverableperiod> GetContractDeliverablePeriods(Guid contractDeliverableId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return
                    xrmContext.sfa_contractdeliverableperiodSet.Where(
                        cdp => cdp.sfa_ContractDeliverableId.Id == contractDeliverableId).ToList();
            }
        }

        private static IList<sfa_contractallocation> GetAllocationsForContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return xrmContext.sfa_contractallocationSet.Where(a => a.sfa_ContractId.Id == contractId).ToList();
            }
        }

        private static sfa_contract GetContract(string contractNumber, int version, int subVersion)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                    List<sfa_contract> matchingContracts = xrmContext.sfa_contractSet.Where(
                        c =>
                            c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion).ToList();

                return matchingContracts.OrderBy(c => c.CreatedOn).First();
            }
        }

        private static sfa_contract GetContract(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return xrmContext.sfa_contractSet.Single(c => c.Id == contractId);
            }
        }

        private static CrmConnection GetCrmConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }
    }

    public class FullContract
    {
        public sfa_contract ChildContract { get; set; }

        public sfa_contract MasterContract { get; set; }

        public IList<FullAllocation> Allocations { get; set; }

        public IList<sfa_contracttransitionhistory> Workflows { get; set; }

        public sfa_contract GetRelatedMasterContract()
        {
            const string contractToContractRelationshipName = "sfa_sfa_contract_sfa_contract";
            const string contractToAllocationRelationshipName = "sfa_sfa_contract_sfa_contractallocation";
            const string contractToWorkflowHistoryRelationshipName = "sfa_sfa_contract_sfa_contracttransitionhistory_Contract";

            Relationship masterContractToChildRelationship = new Relationship(contractToContractRelationshipName)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            Relationship childContractToAllocationRelationship = new Relationship(contractToAllocationRelationshipName)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            Relationship contractToWorkflowHistoryRelationship = new Relationship(contractToWorkflowHistoryRelationshipName)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            List<Entity> allocations = Allocations.Select(aFull => aFull.GetRelatedAllocation() as Entity).ToList();
            List<Entity> workflows = Workflows.Select(wf => wf as Entity).ToList();
            workflows.ForEach(w => w.EntityState = EntityState.Created);
            MasterContract.RelatedEntities.Add(masterContractToChildRelationship, new EntityCollection(new List<Entity> { ChildContract }));

            ChildContract.RelatedEntities.Add(childContractToAllocationRelationship, new EntityCollection(allocations));
            ChildContract.RelatedEntities.Add(contractToWorkflowHistoryRelationship, new EntityCollection(workflows));
            UpdateEntityToAllowUpdate(MasterContract);
            UpdateEntityToAllowCreation(ChildContract);
            ChildContract.sfa_CurrentTask = null;
            
            ChildContract.sfa_HierarchyType = null;
            
            allocations.ForEach(UpdateEntityToAllowCreation);
            
            return MasterContract;
        }

        private static void UpdateEntityToAllowCreation(Entity entity)
        {
            entity.EntityState = EntityState.Created;
           // entity.Id = Guid.NewGuid();
            // entity.Attributes["overriddencreatedon"] = new DateTime(2011, 8, 8);            
        }

        private static void UpdateEntityToAllowUpdate(Entity entity)
        {
            entity.EntityState = EntityState.Changed;
        }
    }

    public class FullAllocation
    {
        public sfa_contractallocation Allocation { get; set; }

        public IList<FullDeliverable> Deliverables { get; set; }

        public sfa_contractallocation GetRelatedAllocation()
        {
            const string allocationToDeliverable = "sfa_sfa_contractallocation_sfa_contractdelive";

            Relationship allocationToDeliverableRelationship = new Relationship(allocationToDeliverable)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            var deliverableIds = Deliverables.Select(d => d.Deliverable.Id).ToList();

            var deliverableIdsInCrm = CrmDeliverableRepository.GetDeliverableIdsForAllocation(Allocation.Id);

            var missingDeliverableIds = deliverableIds.Where(d => !deliverableIdsInCrm.Contains(d));

            var missingDeliverables = Deliverables.Where(d => missingDeliverableIds.Contains(d.Deliverable.Id))
                .Select(fullD => fullD.GetRelatedDeliverable(Allocation.Id) as Entity).ToList();
           
            Allocation.RelatedEntities.Add(allocationToDeliverableRelationship, new EntityCollection(missingDeliverables));
            Allocation.sfa_ContractId = null;
       
            return Allocation;
        }
    }

    public class FullDeliverable
    {
        public sfa_contractdeliverable Deliverable { get; set; }

        public IList<sfa_contractdeliverableperiod> DeliverablePeriods { get; set; }

        public sfa_contractdeliverable GetRelatedDeliverable(Guid allocationId)
        {
            const string deliverableToPeriods = "sfa_contractdeliverable_deliverableperiod";

            Relationship deliverableToDeliverablePeriodRelationship = new Relationship(deliverableToPeriods)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            DeliverablePeriods.ForEach(dp =>
            {
                dp.EntityState = EntityState.Created;
            });

            List<Entity> deliverablePeriods = DeliverablePeriods.Select(dp => dp as Entity).ToList();
            Deliverable.sfa_ContractAllocationId = null;
            Deliverable.sfa_ContractId = null;
           
            Deliverable.sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId);
            
            Deliverable.RelatedEntities.Add(deliverableToDeliverablePeriodRelationship, new EntityCollection(deliverablePeriods));
            Deliverable.EntityState = EntityState.Created;

            return Deliverable;
        }
    }

    internal static class CrmDeliverableRepository
    {

        public static IReadOnlyCollection<Guid> GetDeliverableIdsForAllocation(Guid allocationId)
        {
            using (var xrmContext = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return xrmContext.sfa_contractdeliverableSet.Where(d => d.sfa_ContractAllocationId.Id == allocationId)
                    .Select(d => d.Id)
                    .ToList();
            }
        }

        private static CrmConnection GetCrmConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }
    }
}
