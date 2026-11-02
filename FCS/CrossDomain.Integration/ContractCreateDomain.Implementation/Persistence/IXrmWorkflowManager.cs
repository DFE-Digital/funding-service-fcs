namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Xrm;

    public interface IXrmWorkflowManager
    {
        /// <summary>
        /// Method to return a list of CRM Entities based on a Contract Guid
        /// </summary>
        /// <param name="contractId">The Guid to filter the workflow history on</param>
        /// <returns>A list of workflow history entities</returns>
        List<sfa_contracttransitionhistory> GetWorkflowHistory(Guid contractId);

        /// <summary>
        /// Method to translate a list of workflow history entities ready for CRM import
        /// </summary>
        /// <param name="workflowHistory">The workflow history to translate</param>
        /// <returns>A list of workflow history entities</returns>
        /// <remarks>This method will return another object and will remove the Ids, update the Contract Entity Reference and update the OverridenCreatedOn</remarks>
        List<sfa_contracttransitionhistory> TranslateWorkflowHistory(List<sfa_contracttransitionhistory> workflowHistory);
    }
}