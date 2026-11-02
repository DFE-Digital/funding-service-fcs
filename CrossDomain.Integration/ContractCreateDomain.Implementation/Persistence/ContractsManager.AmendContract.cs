namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using CrossDomain.Integration.Entities.Xrm;
    using Implementation.Entities;
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
        public Guid AmendContract(
            CorporateContractSchema.ExtendedContractType contractToAmend,
            string correlationId, 
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null)
        {
            var xrmContractsToAmend = SetUpContractForSaving(contractToAmend, correlationId);
            Guid contractGuid = Guid.Empty;

            // there will only ever be on item in this list
            foreach (var contract in xrmContractsToAmend.Entities)
            {
                contractGuid = PersistContractToCrm((sfa_contract)contract, insertAllocationIfNotPresent, getExistingContractId);
            }

            return contractGuid;
        }
    }
}