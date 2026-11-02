namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using DocumentsDomain.DataStore;
    using DocumentsDomain.DataStore.Models;

    public class ArchivedDocumentRepository
    {
        public static void RemoveAll()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ArchivedDocument", Schema = "DocumentsDomain", ReqType = "Delete" });

            }
        }

        public static IReadOnlyCollection<ArchivedDocument> GetArchivedDocumentsThatHaveFilenamePrefix(string fileNamePrefix)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                return context.ArchivedDocuments.AsEnumerable()
                    .Where(ad => ad.FileName.StartsWith(fileNamePrefix, StringComparison.CurrentCultureIgnoreCase))
                    .ToList();
            }
        }
    }
}