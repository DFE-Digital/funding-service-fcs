namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Xrm;
    using Implementation.Entities;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;

    public partial class ContractsManager : IContractsManager
    {
        private CrmTranslator _translator;

        public IOrganizationService OrganizationService { get; set; }

        public ILookupManager LookupManager { get; set; }

        public IXrmOrganisationManager XrmOrganisationManager { get; set; }

        public IXrmWorkflowManager XrmWorkflowManager { get; set; }

        public string BatchId { get; set; }

        public bool CheckContractExists(string correlationId)
        {
            return LookupManager.CheckContractExists(correlationId);
        }

        public bool DoesContractVersionExist(string contractNumber, int versionNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber)
                    .ToList()
                    .Any();
            } 
        }

        public ContractRequest.ContractIdentityInfo GetLastApprovedContractIdentityInfo(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                List<ContractRequest.AllocationIdentityInfo> allocations = (
                    from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where c.sfa_number == contractNumber && c.sfa_LastApprovedVersion == true
                    select new ContractRequest.AllocationIdentityInfo(a.sfa_contractallocationnumber, a.sfa_deliveryorganisationukprn)
                ).ToList();

                return allocations.Any() ? new ContractRequest.ContractIdentityInfo(contractNumber, allocations) : null;
            }
        }

        public Guid PersistContractToCrm(
            sfa_contract contractToPersist,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null)
        {
            UpdateDocumentRequiredColumnToYes(contractToPersist);

            List<EntityCollection> relatedEntities = contractToPersist.RelatedEntities.Values.ToList();

            // clear the allocations
            contractToPersist.RelatedEntities.Clear();

            var shouldCreateContract = getExistingContractId == null || getExistingContractId(contractToPersist) == Guid.Empty;
            
            var contractId = shouldCreateContract ? OrganizationService.Create(contractToPersist) : getExistingContractId(contractToPersist);


            // now add the allocations and workflowhistories separately
            relatedEntities.ForEach(c =>
            {
                var contractTransitionHistoriesToAdd = c.Entities.Where(e => e.LogicalName == sfa_contracttransitionhistory.EntityLogicalName)
                    .ToList();
                
                var allocationsToAdd = c.Entities.Where(e => e.LogicalName == sfa_contractallocation.EntityLogicalName).ToList();

                allocationsToAdd.ForEach(a =>
                {
                    UpdateForeignKeyToContract(a, sfa_contractallocation.Fields.sfa_ContractId, contractId);
                    if (insertAllocationIfNotPresent != null)
                    {
                        insertAllocationIfNotPresent(contractToPersist,
                            a.GetAttributeValue<string>(sfa_contractallocation.Fields.sfa_contractallocationnumber),
                            () => OrganizationService.Create(a));
                    }
                    else
                    {
                        OrganizationService.Create(a);
                    }
                });

                contractTransitionHistoriesToAdd.ForEach(cth =>
                {
                    UpdateForeignKeyToContract(cth, "sfa_contract", contractId);
                    OrganizationService.Create(cth);
                });
            });

            return contractId;
        }

        public string GetSubStatusOfLastApproved(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join s in xrmContext.sfa_statusSet on c.sfa_SubStatus.Id equals s.Id
                        where c.sfa_number == contractNumber
                        && c.sfa_LastApprovedVersion == true
                        select s.sfa_name)
                    .ToList()
                    .Single();
            }
        }

        private static void UpdateForeignKeyToContract(Entity entity, string foreignKeyFieldName, Guid contractId)
        {
            if (entity.Attributes.ContainsKey(foreignKeyFieldName))
            {
                entity.Attributes[foreignKeyFieldName] = new EntityReference(sfa_contract.EntityLogicalName, contractId);
            }
            else
            {
                entity.Attributes.Add(foreignKeyFieldName, new EntityReference(sfa_contract.EntityLogicalName, contractId));
            }
        }

        private void UpdateDocumentRequiredColumnToYes(sfa_contract contractToPersist)
        {
            var fundingType = OrganizationService.Retrieve(CrmContractFieldName.FundingType,
                       contractToPersist.sfa_FundingType.Id,
                       new ColumnSet("sfa_documentationnotrequired"));

            contractToPersist.sfa_DocumentationRequired =
                !fundingType.GetAttributeValue<bool?>("sfa_documentationnotrequired") ?? true;
        }

        private void AddCorrelationIdToContract(string correlationId, Entity contract)
        {
            const string contractTypeName = "contractType";
            var column =
                CrmFieldMapper.GetMappings(contractTypeName, CrmFieldMapper.CorrelationIdPropertyName).First();
            contract.Attributes.Add(column.CrmColumnName, correlationId);
        }

        private void AddDocumentationRequiredToContract(Entity contract)
        {
            var fundingType = OrganizationService.Retrieve(CrmContractFieldName.FundingType,
                    contract.GetAttributeValue<EntityReference>("sfa_fundingtype").Id,
                    new ColumnSet("sfa_documentationnotrequired"));

                contract.Attributes.Add(CrmContractFieldName.DocumentRequired,
                    !fundingType.GetAttributeValue<bool?>("sfa_documentationnotrequired") ?? true);
        }

        private LookupCriteria GetLookupCriteria(ExtendedContractType contract)
        {
            LookupCriteria lookupCriteria = new LookupCriteria();

            if (contract.hierarchyType == hierarchyType.MASTERCONTRACT)
            {
                AddCriteriaItem(lookupCriteria.ContractTypes, contract.contractType1);
                AddCriteriaItem(lookupCriteria.FundingTypes, CrmFieldMapper.GetPrimaryKeyFieldValue(contract.fundingType));
                AddCriteriaItem(lookupCriteria.SubStatus, contract.contractStatus?.status);
                AddCriteriaItem(lookupCriteria.UkPrns, contract.contractor.ukprn.ToString());

                foreach (var subContract in contract.contracts)
                {
                    GetLookupCriteriaForChildContract(subContract, lookupCriteria);
                }
            }
            else
            {
                GetLookupCriteriaForChildContract(contract, lookupCriteria);
            }

            return lookupCriteria;
        }

        private void GetLookupCriteriaForChildContract(ExtendedContractType contract, LookupCriteria lookupCriteria)
        {
            AddCriteriaItem(lookupCriteria.ContractTypes, contract.contractType1);

            // we are not interested in the Funding Type from the sub as we will
            // always use the Master's
            AddCriteriaItem(lookupCriteria.FundingTypes, CrmFieldMapper.GetPrimaryKeyFieldValue(contract.fundingType));
            AddCriteriaItem(lookupCriteria.SubStatus, contract.contractStatus.status);
            AddCriteriaItem(lookupCriteria.Periods, CrmFieldMapper.GetPeriodPk(contract.period));

            foreach (var allocation in contract.contractAllocations)
            {
                AddCriteriaItem(lookupCriteria.Periods, CrmFieldMapper.GetPeriodPk(allocation.period));
                AddCriteriaItem(lookupCriteria.FundingStreams, CrmFieldMapper.GetPrimaryKeyFieldValue(allocation.fundingStream));
                AddCriteriaItem(lookupCriteria.FundingStreamPeriods, CrmFieldMapper.GetFundingStreamPeriodPk(allocation));
                AddCriteriaItem(lookupCriteria.UnitsOfProcurement, allocation.uopCode);
                AddCriteriaItem(lookupCriteria.UkPrns, allocation.DeliveryOrganisation);

                if (allocation.contractDeliverables != null)
                {
                    foreach (var deliverables in allocation.contractDeliverables)
                    {
                        foreach (var deliverablePeriod in deliverables.contractDeliverablePeriods)
                        {
                            AddCriteriaItem(lookupCriteria.PeriodTypeType, CrmFieldMapper.GetPrimaryKeyFieldValue(deliverablePeriod.periodType));
                        }
                    }
                }
            }
        }

        private void AddCriteriaItem(HashSet<string> criteriaSet, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
            {
                if (criteriaSet == null)
                {
                    criteriaSet = new HashSet<string>();
                }

                criteriaSet.Add(value);
            }
        }

        private void AddCriteriaItem(HashSet<CrmCompositeKey> criteriaSet, CrmCompositeKey compositeKey)
        {
            if (compositeKey != null && compositeKey.KeyFields.Count > 0)
            {
                if (criteriaSet == null)
                {
                    criteriaSet = new HashSet<CrmCompositeKey>();
                }

                criteriaSet.Add(compositeKey);
            }
        }

        private EntityCollection SetUpContractForSaving(ExtendedContractType contractToAmend, string correlationId)
        {
            LookupManager.BatchId = BatchId;
            _translator = new CrmTranslator(LookupManager);

            contractToAmend.contracts.ForEach(childContract =>
            {
                ISet<Contractor> distinctOrganisations = GetDistinctContractors(childContract);

                distinctOrganisations.ToList().ForEach(CreateOrganisationIfNecessary);
            });
            
            LookupCriteria lookupCriteria = GetLookupCriteria(contractToAmend);
            LookupManager.Lookup(lookupCriteria);

            EntityCollection contractsCollection = new EntityCollection();

            foreach (var childContractToAmend in contractToAmend.contracts)
            {
                EntityCollection contractAllocationCollection = new EntityCollection();
                ProcessAllocations(contractAllocationCollection, childContractToAmend.contractAllocations);

                childContractToAmend.contractor = contractToAmend.contractor;
                childContractToAmend.fundingType = contractToAmend.fundingType;

                sfa_contract xrmContractToAmend = _translator.TranslateContract(childContractToAmend).ToEntity<sfa_contract>();
                xrmContractToAmend.Id = Guid.NewGuid();
                AddCorrelationIdToContract(correlationId, xrmContractToAmend);

                var contractAllocationRelationship =
                    new Relationship(CrmEntityRelationshipName.ContractToAllocation)
                    {
                        PrimaryEntityRole = EntityRole.Referenced
                    };
                xrmContractToAmend.RelatedEntities.Add(contractAllocationRelationship, contractAllocationCollection);

                contractsCollection.Entities.Add(xrmContractToAmend);
            }

            return contractsCollection;
        }

        private ISet<Contractor> GetDistinctContractors(ExtendedContractType contract)
        {
            int childContractUkprn = contract.contractor.ukprn;

            ISet<Contractor> distinctOrganisations = contract
                .contractAllocations
                .Where(a => a.HasDeliveryOrganisation()
                            && a.DeliveryOrganisationDetail.ukprn != childContractUkprn)
                .Select(a => a.DeliveryOrganisationDetail)
                .ToHashSet();

            distinctOrganisations.Add(contract.contractor);

            return distinctOrganisations;
        }
    }
}
