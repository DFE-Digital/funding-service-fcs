namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System;

    public class SystemDate : IDate
    {
        public DateTime GetCalculationDate()
        {
            return DateTime.UtcNow;
        }

        public DateTime GetCalculationDateWithKey(string key)
        {
            return DateTime.UtcNow;
        }
    }
}