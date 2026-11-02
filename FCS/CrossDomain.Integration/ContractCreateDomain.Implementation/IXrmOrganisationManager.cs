namespace SFA.FCT.ContractCreateDomain.Implementation
{
    using System;
    using CrossDomain.Integration.Entities;
    using Entities;

    /// <summary>
    /// Interface for persisting organisation data in a CRM System
    /// </summary>
    public interface IXrmOrganisationManager
    {
        /// <summary>
        /// Creates a new instance of an Organisation in a CRM system. 
        /// </summary>
        /// <param name="org">An object representing the organisation</param>
        /// <returns>The guid of the newly created organisation</returns>
        Guid CreateOrganisationIfNotExists(ContractOrganisation org);

        /// <summary>
        /// Updates an existing Organisation in a CRM system
        /// </summary>
        /// <param name="org">An object representing the organisation to be updated</param>
        void UpdateOrganisation(organisation org);
    }
}
