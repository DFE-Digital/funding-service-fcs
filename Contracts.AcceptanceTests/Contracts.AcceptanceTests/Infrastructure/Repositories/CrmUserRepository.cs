namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Services;

    public static class CrmUserRepository
    {
        public static Guid GetUserId(string userName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.SystemUserSet.First(u => u.FullName == userName).Id;
            }
        }

        public static string GetUserName(Guid id)
        {
            string userName = null;
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                userName = context.SystemUserSet.SingleOrDefault(u => u.Id == id)?.FullName;
            }

            if (userName == null)
            {
                using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
                {
                    userName = context.TeamSet.SingleOrDefault(t => t.Id == id)?.Name;
                }
            }

            return userName;
        }
    }
}
