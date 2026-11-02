
namespace Datafix.Tests.Repositories
{
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmAccountRepository
    {
        public static void UpdateName(int ukprn, string name)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var crmId = context.AccountSet.Where(a => a.sfa_UKPRN == ukprn.ToString()).Select(a => a.Id).Single();

                Account account = new Account
                {
                    Id = crmId,
                    Name = name,
                    EntityState = EntityState.Changed
                };

                organizationService.Update(account);
            }
        }
    }
}
