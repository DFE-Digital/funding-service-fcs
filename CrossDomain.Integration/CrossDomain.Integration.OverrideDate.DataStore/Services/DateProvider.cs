namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Entities.Data;

    public class DateProvider : IDateProvider
    {
        public DateTime GetDate(ConnectionInfo connectionInfo)
        {
            bool useRealDate = bool.Parse(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? DateTime.UtcNow : DateTime.SpecifyKind(GetOverrideDate() ?? DateTime.UtcNow, DateTimeKind.Utc);

            DateTime? GetOverrideDate()
            {
                using (IOverrideDateDBContext context = new OverrideDateDBContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    return context.OverrideDate.SingleOrDefault()?.SystemOverrideDate;
                }
            }
        }
    }
}