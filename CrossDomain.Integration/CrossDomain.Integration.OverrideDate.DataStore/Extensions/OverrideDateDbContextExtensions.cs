namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Extensions
{
    using System;
    using System.Globalization;
    using Model;

    public static class OverrideDateDbContextExtensions
    {
        public static void SetOverrideDate(this IOverrideDateDBContext dbContext, DateTime overrideDate)
        {
            ResetOverrideDate(dbContext);

            dbContext.OverrideDate.Add(new OverrideDate
            {
                SystemOverrideDate = overrideDate
            });

            dbContext.SaveChanges();
        }

        public static void SetOverrideDate(this IOverrideDateDBContext dbContext, string overrideDate)
        {
            SetOverrideDate(dbContext, DateTime.ParseExact(overrideDate, "dd/MM/yyyy", CultureInfo.CurrentCulture));
        }

        public static void ResetOverrideDate(this IOverrideDateDBContext dbContext)
        {
            foreach (OverrideDate overrideDate in dbContext.OverrideDate)
            {
                dbContext.OverrideDate.Remove(overrideDate);
            }

            dbContext.SaveChanges();
        }
    }
}
