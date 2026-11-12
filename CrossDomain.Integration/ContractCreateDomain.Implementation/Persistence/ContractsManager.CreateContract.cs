namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Implementation.Entities;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Xrm;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;

    public partial class ContractsManager
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="contract"></param>
        /// <param name="correlationId"></param>
        public Guid CreateContract(
            ExtendedContractType contract,
            string correlationId,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null)
        {
            ExtendedContractType childContract = contract.contracts.First();

            ISet<Contractor> distinctOrganisations = GetDistinctContractors(childContract);

            distinctOrganisations.ForEach(CreateOrganisationIfNecessary);

            LookupManager.BatchId = BatchId;
            if (contract.contracts.Count > 0)
            {
                contract.contractType1 = childContract.contractType1;
            }

            _translator = new CrmTranslator(LookupManager);
            LookupCriteria lookupCriteria = GetLookupCriteria(contract);
            LookupManager.Lookup(lookupCriteria);

            Entity masterContractEntity = _translator.TranslateContract(contract);
            AddCorrelationIdToContract(correlationId, masterContractEntity);

            EntityCollection subContractCollection = ProcessSubContract(contract);
    
            AddAttributesToEntityThatAreNotOnTheExtendedContractType(subContractCollection, correlationId);

            Relationship subContractsRelationship = new Relationship(CrmEntityRelationshipName.ContractToContract)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };
            masterContractEntity.RelatedEntities.Add(subContractsRelationship, subContractCollection);

            List<EntityCollection> allocationEntityCollections = masterContractEntity.RelatedEntities.SelectMany(childCrmContracts =>
            {
                return childCrmContracts.Value.Entities.SelectMany(c => c.RelatedEntities.Values).ToList();
            }).ToList();

            // clear the allocations
            masterContractEntity.RelatedEntities.Values.ForEach(cC =>
            {
                cC.Entities.ForEach(c => c.RelatedEntities.Clear());
            });

            bool ShouldCreateContract() => getExistingContractId == null || getExistingContractId(contract) == Guid.Empty;
            bool HaveWePreviouslyCreatedContract() => !ShouldCreateContract();

            Guid masterContractId = Guid.Empty;
            if (ShouldCreateContract())
            {
                masterContractId = OrganizationService.Create(masterContractEntity);
            }
            
            // now add the allocations separately
           
            allocationEntityCollections.ForEach(c => c.Entities.ForEach(a =>
            {
                if (a.LogicalName == sfa_contractallocation.EntityLogicalName)
                {
                    if (HaveWePreviouslyCreatedContract() && getExistingContractId != null)
                    {
                        a["sfa_contractid"] = new EntityReference(sfa_contract.EntityLogicalName, getExistingContractId(contract));
                    }

                    if (insertAllocationIfNotPresent != null)
                    {
                        insertAllocationIfNotPresent(contract,
                            a.GetAttributeValue<string>("sfa_contractallocationnumber"),
                            () => OrganizationService.Create(a));
                    }
                    else
                    {
                        OrganizationService.Create(a);
                    }
                }
            }));

            return masterContractId;
        }

        private void AddAttributesToEntityThatAreNotOnTheExtendedContractType(EntityCollection subContractCollection, string correlationId)
        {
            foreach (var subContract in subContractCollection.Entities)
            {
                AddCorrelationIdToContract(correlationId, subContract);
            }
        }

        private void CreateOrganisationIfNecessary(Contractor contractor)
        {
            ContractOrganisation org = new ContractOrganisation
            {
                Name = contractor.legalName,
                UKPRN = contractor.ukprn.ToString(),
                OrganisationId = contractor.organisationIdentifier,
                Status = contractor.Status,
                Upin = contractor.Upin,
                CompanyNumber = contractor.registeredCompanyNumber,
                CharityNumber = contractor.CharityNumber,
            };

            org.Address = contractor.GetAddress();

            XrmOrganisationManager.CreateOrganisationIfNotExists(org);
        }

        private EntityCollection ProcessSubContract(ExtendedContractType contract)
        {
            EntityCollection subContractCollection = new EntityCollection()
            {
                EntityName = CrmEntityName.Contract
            };

            foreach (var subContract in contract.contracts)
            {
                EntityCollection contractAllocationCollection = new EntityCollection();
                ProcessAllocations(contractAllocationCollection, subContract.contractAllocations);

                subContract.contractor = contract.contractor;
                subContract.fundingType = contract.fundingType;
                Entity subContractEntity = _translator.TranslateContract(subContract);
                subContractEntity.Id = Guid.NewGuid();
                subContractCollection.Entities.Add(subContractEntity);
                contractAllocationCollection.Entities.ForEach(a =>
                {
                    a.Attributes.Add("sfa_contractid", new EntityReference(sfa_contract.EntityLogicalName, subContractEntity.Id));
                });

                Relationship contractAllocationRelationship = new Relationship(CrmEntityRelationshipName.ContractToAllocation)
                {
                    PrimaryEntityRole = EntityRole.Referenced
                };
                subContractEntity.RelatedEntities.Add(contractAllocationRelationship, contractAllocationCollection);
            }

            return subContractCollection;
        }

        private void ProcessAllocations(EntityCollection contractAllocationCollection, List<ExtendedContractAllocation> contractAllocations)
        {
            foreach (var allocation in contractAllocations)
            {
                // allocation.FundingStreamPeriodCode = allocation.FundingStreamCode + allocation.Period.PeriodYear;
                EntityCollection contractDeliverableCollection = new EntityCollection();
                Entity allocationEntity = new Entity(CrmEntityName.ContractAllocation) {Id = Guid.NewGuid()};
                if (allocation.contractDeliverables != null)
                {
                    ProcessDeliverables(
                        contractDeliverableCollection, 
                        allocation.contractDeliverables, 
                        allocation.contractAllocationNumber, 
                        new EntityReference(CrmEntityName.ContractAllocation, allocationEntity.Id));
                }

                _translator.PopulateAttributesViaFieldMapping(allocationEntity, allocation);
                contractAllocationCollection.Entities.Add(allocationEntity);

                Relationship contractDeliverableRelationship = new Relationship(CrmEntityRelationshipName.AllocationToDeliverable)
                {
                    PrimaryEntityRole = EntityRole.Referenced
                };

                allocationEntity.RelatedEntities.Add(contractDeliverableRelationship, contractDeliverableCollection);
            }
        }

        private void ProcessAllocations(EntityCollection contractAllocationCollection, List<contractAllocationsContractAllocation> contractAllocations)
        {
            foreach (var allocation in contractAllocations)
            {
                // allocation.FundingStreamPeriodCode = allocation.FundingStreamCode + allocation.Period.PeriodYear;
                EntityCollection contractDeliverableCollection = new EntityCollection();
                Entity allocationEntity = new Entity(CrmEntityName.ContractAllocation) {Id = Guid.NewGuid()};

                if (allocation.contractDeliverables != null)
                {
                    ProcessDeliverables(
                        contractDeliverableCollection, 
                        allocation.contractDeliverables, 
                        allocation.contractAllocationNumber, 
                        new EntityReference(CrmEntityName.ContractAllocation, allocationEntity.Id));
                }

                _translator.PopulateAttributesViaFieldMapping(allocationEntity, allocation);
                contractAllocationCollection.Entities.Add(allocationEntity);

                Relationship contractDeliverableRelationship = new Relationship(CrmEntityRelationshipName.AllocationToDeliverable)
                {
                    PrimaryEntityRole = EntityRole.Referenced
                };
            
                allocationEntity.RelatedEntities.Add(contractDeliverableRelationship, contractDeliverableCollection);
            }
        }

        private void ProcessDeliverables(EntityCollection contractDeliverableCollection, List<contractDeliverablesTypeContractDeliverable> contractDeliverables, string contractAllocationReference, EntityReference allocationEntityRef)
        {
            foreach (var contractDeliverable in contractDeliverables)
            {
                var contractDeliverablePeriodsCollection = new EntityCollection();

                ProcessDeliverablePeriods(contractDeliverablePeriodsCollection, contractDeliverable.contractDeliverablePeriods);

                var childContractDeliverablesCollection = new EntityCollection();

                ProcessDeliverables(childContractDeliverablesCollection, contractDeliverable.contractDeliverables, contractAllocationReference, allocationEntityRef);

                var deliverableEntity = new Entity(CrmEntityName.ContractDeliverable);
                _translator.PopulateAttributesViaFieldMapping(deliverableEntity, contractDeliverable);
                _translator.PopulateAttributesViaFieldMapping(deliverableEntity, contractDeliverable.deliverable);

                // Update Allocation Reference
                deliverableEntity[CrmDeliverableFieldName.AllocationReference] = contractAllocationReference;

                contractDeliverableCollection.Entities.Add(deliverableEntity);

                var contractDeliverableRelationship =
                   new Relationship(CrmEntityRelationshipName.DeliverableToDeliverable)
                   {
                       PrimaryEntityRole = EntityRole.Referenced
                   };

                deliverableEntity.RelatedEntities.Add(contractDeliverableRelationship, childContractDeliverablesCollection);

                var contractDeliverablePeriodRelationship =
                    new Relationship(CrmEntityRelationshipName.DeliverableToPeriods)
                    {
                        PrimaryEntityRole = EntityRole.Referenced
                    };

                deliverableEntity.RelatedEntities.Add(contractDeliverablePeriodRelationship, contractDeliverablePeriodsCollection);
                deliverableEntity.Attributes.Add(new KeyValuePair<string, object>("sfa_contractallocationid", allocationEntityRef));
            }
        }
        
        private void ProcessDeliverablePeriods(EntityCollection contractDeliverablePeriodsCollection, List<contractDeliverablePeriodsTypeContractDeliverablePeriod> contractDeliverablePeriods)
        {
            foreach (var contractDeliverablePeriod in contractDeliverablePeriods)
            {
                Entity deliverablePeriodEntity = new Entity(CrmEntityName.ContractDeliverablePeriod);
                _translator.PopulateAttributesViaFieldMapping(deliverablePeriodEntity, contractDeliverablePeriod);
                contractDeliverablePeriodsCollection.Entities.Add(deliverablePeriodEntity);
            }
        }
    }
}