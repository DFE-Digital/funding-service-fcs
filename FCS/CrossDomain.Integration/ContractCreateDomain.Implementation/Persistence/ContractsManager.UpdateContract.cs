namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;

    public partial class ContractsManager
    {
        /// <summary>
        /// Public Method to Update an existing contract based on the contract passed in.
        /// </summary>
        /// <param name="contractToUpdate">The new contract values, this is a contracType from the corporate schema</param>
        /// <param name="correlationId">The new contract values, this is a contracType from the corporate schema</param>
        /// <returns>A contractType record if a matching record is found, null if none are returned</returns>
        /// <remarks>This is currently achieved by creating a new version of the contract, rather than updating the existing</remarks>
        public Guid UpdateContract(contractType contractToUpdate, string correlationId)
        {
            Guid contractGuid = Guid.Empty;
            LookupManager.BatchId = BatchId;
            _translator = new CrmTranslator(LookupManager);

            LookupCriteria lookupCriteria = GetLookupCriteria(contractToUpdate);
            LookupManager.Lookup(lookupCriteria);

            // there will only ever be one contract in this list
            foreach (var childContractToUpdate in contractToUpdate.contracts)
            {
                EntityCollection contractAllocationCollection = new EntityCollection();
                ProcessAllocations(contractAllocationCollection, childContractToUpdate.contractAllocations);

                childContractToUpdate.contractor = contractToUpdate.contractor;
                childContractToUpdate.fundingType = contractToUpdate.fundingType;
                sfa_contract xrmContractToUpdate = _translator.TranslateContract(childContractToUpdate).ToEntity<sfa_contract>();
                xrmContractToUpdate.Id = Guid.NewGuid();
                contractAllocationCollection.Entities.ForEach(a =>
                {
                    a.Attributes.Add("sfa_contractid", new EntityReference(sfa_contract.EntityLogicalName, xrmContractToUpdate.Id));
                });

                AddCorrelationIdToContract(correlationId, xrmContractToUpdate);

                var contractAllocationRelationship =
                    new Relationship(CrmEntityRelationshipName.ContractToAllocation)
                    {
                        PrimaryEntityRole = EntityRole.Referenced
                    };
                xrmContractToUpdate.RelatedEntities.Add(contractAllocationRelationship, contractAllocationCollection);

                sfa_contract currentXrmContract = GetXrmContract(childContractToUpdate.contractNumber);

                ProcessXrmContract(xrmContractToUpdate, currentXrmContract);

                contractGuid = PersistContractToCrm(xrmContractToUpdate);
            }

            return contractGuid;
        }

        #region for Update contract
        private LookupCriteria GetLookupCriteria(contractType contract)
        {
            LookupCriteria lookupCriteria = new LookupCriteria();

            if (contract.hierarchyType == hierarchyType.MASTERCONTRACT)
            {
                AddCriteriaItem(lookupCriteria.ContractTypes, contract.contractType1);
                AddCriteriaItem(lookupCriteria.FundingTypes, CrmFieldMapper.GetPrimaryKeyFieldValue(contract.fundingType));
                AddCriteriaItem(lookupCriteria.SubStatus, contract.contractStatus.status);
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

        private void GetLookupCriteriaForChildContract(contractType contract, LookupCriteria lookupCriteria)
        {
            AddCriteriaItem(lookupCriteria.ContractTypes, contract.contractType1);

            // we are not interested in the Funding Type from the sub as we will
            // always use the Master's
            AddCriteriaItem(lookupCriteria.ContractTypes, CrmFieldMapper.GetPrimaryKeyFieldValue(contract.contractType1));
            AddCriteriaItem(lookupCriteria.FundingTypes, CrmFieldMapper.GetPrimaryKeyFieldValue(contract.fundingType));
            AddCriteriaItem(lookupCriteria.SubStatus, contract.contractStatus.status);
            AddCriteriaItem(lookupCriteria.Periods, CrmFieldMapper.GetPeriodPk(contract.period));

            foreach (var allocation in contract.contractAllocations)
            {
                AddCriteriaItem(lookupCriteria.Periods, CrmFieldMapper.GetPeriodPk(allocation.period));
                AddCriteriaItem(lookupCriteria.FundingStreams, CrmFieldMapper.GetPrimaryKeyFieldValue(allocation.fundingStream));
                AddCriteriaItem(lookupCriteria.FundingStreamPeriods, CrmFieldMapper.GetFundingStreamPeriodPk(allocation));
                AddCriteriaItem(lookupCriteria.UnitsOfProcurement, allocation.uopCode);

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
        #endregion

        /// <summary>
        /// Private method to process the contract, this will add the workflow history and update key fields to allow the contract to be persisted as a new version
        /// </summary>
        /// <param name="xrmContract">The entity corresponding to the CRM Contract</param>
        /// <param name="previousContract">The previous contract</param>
        private void ProcessXrmContract(sfa_contract xrmContract, sfa_contract previousContract)
        {
            var contractWorkflowHistoryCollection = new EntityCollection();

            var workflowHistoryRelationship = new Relationship(CrmEntityRelationshipName.ContractToWorkflowHistory)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            // Get workflow history for previous contract
            List<sfa_contracttransitionhistory> workflowHistoryList =
                XrmWorkflowManager.GetWorkflowHistory(previousContract.Id);

            // Translate workflow history
            XrmWorkflowManager.TranslateWorkflowHistory(workflowHistoryList)
                .ForEach(w => contractWorkflowHistoryCollection.Entities.Add(w));

            // Add translated workflow history to previous contract
            xrmContract.RelatedEntities.Add(workflowHistoryRelationship, contractWorkflowHistoryCollection);

            // Update version numbers
            xrmContract.sfa_LatestVersion = true;
            xrmContract.sfa_SubVersion = xrmContract.sfa_SubVersion + 1 ?? xrmContract.sfa_SubVersion;
            xrmContract.sfa_PreviousVersion = new EntityReference(sfa_contract.EntityLogicalName, previousContract.Id);

            // Maintain previous ownwers
            xrmContract.OwnerId = previousContract.OwnerId;
            xrmContract.sfa_ContractAdviser = previousContract.sfa_ContractAdviser;

            // Maintain previous master contract
            xrmContract.sfa_ParentContractId = previousContract.sfa_ParentContractId;

            // Override created on
            xrmContract.OverriddenCreatedOn = xrmContract.CreatedOn;
        }
    }
}
