namespace SFA.FCT.CrossDomain.Integration.Common.Extensions
{
    using System;

    public static class DateTimeExtensions
    {
        public static string ToSqlServerCompatibleString(this DateTime dt)
        {
            var checkedDateTime = dt;

            if (checkedDateTime.Year < 1753)
            {
                checkedDateTime = new DateTime(1753, 1, 1);
            }

            return checkedDateTime.ToString("s");
        }
    }
}
