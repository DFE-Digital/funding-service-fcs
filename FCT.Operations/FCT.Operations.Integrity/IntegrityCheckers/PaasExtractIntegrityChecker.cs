namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore;
    using Services;
    using Utils;

    public abstract class PaasExtractIntegrityChecker<TExtractRow> : IIntegrityChecker where TExtractRow : class
    {
        private readonly ContractManagementDbContext _dbContext;        

        protected PaasExtractIntegrityChecker(ContractManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        protected abstract string SqlResourceName { get; }

        public IntegrityCheckResult CheckValues()
        {
            string sqlQuery = GetSqlScriptFromResource();
            IList<TExtractRow> extractRows = _dbContext.Database.SqlQuery<TExtractRow>(sqlQuery).ToList();
            
            CsvWriter<TExtractRow> csvWriter = new CsvWriter<TExtractRow>();
            string csvContent = csvWriter.CreateCsv(extractRows ?? new List<TExtractRow>());

            return new IntegrityCheckResult(foundIssues: false, issuesCsv: csvContent);
        }

        private string GetSqlScriptFromResource()
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(SqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
