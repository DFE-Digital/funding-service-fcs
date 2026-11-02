namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;

    public class XrmWorkflowManager : IXrmWorkflowManager
    {
        #region Injected Dependencies

        public IOrganizationService OrganizationService { get; set; }

        #endregion

        /// <summary>
        /// Method to return a list of CRM Entities based on a Contract Guid
        /// </summary>
        /// <param name="contractId">The Guid to filter the workflow history on</param>
        /// <returns>A list of workflow history entities</returns>
        public virtual List<sfa_contracttransitionhistory> GetWorkflowHistory(Guid contractId)
        {
            if (contractId == Guid.Empty)
            {
                throw new ArgumentNullException("contractId", @"Contract ID was not specified for workflow history");
            }

            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return
                    (from w in xrmContext.sfa_contracttransitionhistorySet where w.sfa_Contract.Id == contractId orderby w.CreatedOn descending select w)
                        .ToList();
            }
        }

        /// <summary>
        /// Method to translate a list of workflow history entities ready for CRM import
        /// </summary>
        /// <param name="workflowHistory">The workflow history to translate</param>
        /// <returns>A list of workflow history entities</returns>
        /// <remarks>This method will return another object and will remove the Ids, update the Contract Entity Reference and update the OverridenCreatedOn</remarks>
        public List<sfa_contracttransitionhistory> TranslateWorkflowHistory(List<sfa_contracttransitionhistory> workflowHistory)
        {
            List<sfa_contracttransitionhistory> newWorkflowHistory = new List<sfa_contracttransitionhistory>();
            workflowHistory.ForEach(w =>
            {
                var newWorkflow = w.Clone(false).ToEntity<sfa_contracttransitionhistory>();
                newWorkflow.Id = Guid.Empty;
                newWorkflow.Attributes.Remove(w.LogicalName + "id");
                newWorkflow.EntityState = EntityState.Created;
                newWorkflowHistory.Add(newWorkflow);
            });
            return newWorkflowHistory;
        }
    }
}
