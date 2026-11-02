namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using LanguageExt;
    using Microsoft.Xrm.Sdk;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        /// <summary>
        /// Under Termination
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <returns></returns>
        public Option<(string subStatus, DateTime? terminationDate)> GetLastApprovedContractSubStatusAndTerminationDate(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                var lastApprovedInfo = (from c in xrmServiceContext.sfa_contractSet
                        join subStatus in xrmServiceContext.sfa_statusSet on c.sfa_SubStatus.Id equals subStatus.Id
                        where c.sfa_number == contractNumber  && c.sfa_LastApprovedVersion == true
                        select new {subStatus.sfa_name, c.sfa_terminationdate})
                    .SingleOrDefault();

                if (lastApprovedInfo != null)
                {
                    return (lastApprovedInfo.sfa_name, lastApprovedInfo.sfa_terminationdate);
                }

                return Option<(string subStatus, DateTime? terminationDate)>.None;
            }
        }
    }
}
