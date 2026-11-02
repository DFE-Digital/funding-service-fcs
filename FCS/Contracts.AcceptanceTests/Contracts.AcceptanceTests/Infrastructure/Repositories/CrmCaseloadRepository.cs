namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmCaseloadRepository
    {
        public static void CreateCaseloadIfNotThere(string advisorName, string ukrpn, EntityReference status)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var caseLoad = context.sfa_caseloadSet.FirstOrDefault(c => c.sfa_UKPRN == ukrpn);
                if (caseLoad != null)
                {
                    AssignUser(advisorName, caseLoad.Id);
                }
                else
                {
                    caseLoad = new sfa_caseload
                    {
                        sfa_UKPRN = ukrpn,
                        sfa_OrganisationId = GetOrganisation(ukrpn),
                        sfa_Status = status
                    };

                    Guid caseLoadId = CrmConnectionFactory.GetConnection().Create(caseLoad);
                    AssignUser(advisorName, caseLoadId);
                }
            }
        }

        private static void AssignUser(string userName, Guid caseLoadId)
        {
            AssignRequest assignRequest = new AssignRequest
            {
                Assignee = new EntityReference(SystemUser.EntityLogicalName, GetUser(userName).Id),

                Target = new EntityReference(sfa_caseload.EntityLogicalName, caseLoadId)
            };

            CrmConnectionFactory.GetConnectionForSpecificUser(userName).Execute(assignRequest);
        }

        private static EntityReference GetUser(string userName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.SystemUserSet.FirstOrDefault(u => u.FullName == userName)?.ToEntityReference();
            }
        }

        private static EntityReference GetOrganisation(string ukprn)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.AccountSet.FirstOrDefault(u => u.sfa_UKPRN == ukprn)?.ToEntityReference();
            }
        }
    }
}
