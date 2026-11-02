namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Xrm;
    using Implementation.Entities;
    using Microsoft.Xrm.Sdk;
    using CorporateContractSchema = CrossDomain.Integration.Entities.CorporateContract;

    public partial class ContractsManager
    {
        /// <summary>
        /// Public Method to Amend (create new) an existing contract based on the contract passed in.
        /// </summary>
        /// <param name="contractToAmend">The new contract values, this is a contracType from the corporate schema</param>
        /// <param name="correlationId">The new contract values, this is a contracType from the corporate schema</param>
        /// <returns>A contractType record if a matching record is found, null if none are returned</returns>
        /// <remarks>This is currently achieved by creating a new version of the contract, rather than updating the existing</remarks>
        public Guid UpdateAmendedContract(
            CorporateContractSchema.ExtendedContractType contractToAmend,
            string correlationId,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null)
        {
            var xrmContractsToAmend = SetUpContractForSaving(contractToAmend, correlationId);
            Guid contractGuid = Guid.Empty;

            // this will only contain one item
            foreach (var contract in xrmContractsToAmend.Entities)
            {
                ProcessContractCopyWorkflowHistory((sfa_contract)contract);

                ProcessContractOverriddenCreatedOn((sfa_contract)contract);

                contractGuid = PersistContractToCrm((sfa_contract)contract, insertAllocationIfNotPresent, getExistingContractId);
            }

            return contractGuid;
        }

        /// <summary>
        /// Private method to process the contract, this will add the workflow history and update key fields to allow the contract to be persisted as a new version
        /// </summary>
        /// <param name="xrmContract">The entity corresponding to the CRM Contract</param>
        internal void ProcessContractCopyWorkflowHistory(sfa_contract xrmContract)
        {
            var contractWorkflowHistoryCollection = new EntityCollection();

            var workflowHistoryRelationship = new Relationship(CrmEntityRelationshipName.ContractToWorkflowHistory)
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            // Get workflow history for previous contract
            List<sfa_contracttransitionhistory> workflowHistoryList =
                XrmWorkflowManager.GetWorkflowHistory(xrmContract.sfa_PreviousVersion.Id);

            workflowHistoryList.ForEach(wfh => wfh.sfa_Contract.Id = xrmContract.Id);

            // Translate workflow history
            XrmWorkflowManager.TranslateWorkflowHistory(workflowHistoryList)
                .ForEach(w => contractWorkflowHistoryCollection.Entities.Add(w));

            // Add translated workflow history to previous contract
            xrmContract.RelatedEntities.Add(workflowHistoryRelationship, contractWorkflowHistoryCollection);
        }

        /// <summary>
        /// Private method to process the contract, this will add the workflow history and update key fields to allow the contract to be persisted as a new version
        /// </summary>
        /// <param name="xrmContract">The entity corresponding to the CRM Contract</param>
        internal void ProcessContractOverriddenCreatedOn(sfa_contract xrmContract)
        {
            // Override created on
            xrmContract.OverriddenCreatedOn = xrmContract.CreatedOn;
        }
    }
}