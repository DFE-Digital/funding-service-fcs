namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using ContractManagement.DataStore;
    using Extensions;
    using System.Linq;

    public static class CreatedContractRepository
    {
        public static void RemoveRange(string[] contractNumbers)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.RemoveWhere(dl => contractNumbers.Contains(dl.ContractNumber));
                context.SaveChanges();
            }
        }

        public static void RemoveCreatedContract(string contractNumber, string contractVersionNumber, string contractSubVersionNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                SqlParameter[] parameters = {
                new SqlParameter("@contractNumber", contractNumber),
                new SqlParameter("@contractVersionNumber", contractVersionNumber),
                new SqlParameter("@contractSubVersionNumber", contractSubVersionNumber)};

                context.Database.ExecuteSqlCommand("dbo.sp_RemoveCreatedContract @contractNumber,@contractVersionNumber,@contractSubVersionNumber", parameters);
            }

        }

        public static void AddCreatedContractOrUpdateCreatedDate(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, DateTime createdDate)
        {
            if (IsCreatedContractPresent(contractNumber, contractVersionNumber, contractSubVersionNumber))
            {
                UpdateCreatedContractCreatedDate(contractNumber, contractVersionNumber, contractSubVersionNumber,
                    createdDate);
            }
            else
            {
                using (var context = new ContractManagementDbContext())
                {
                    SqlParameter[] parameters = {
                    new SqlParameter("@contractNumber", contractNumber),
                    new SqlParameter("@contractVersionNumber", contractVersionNumber),
                    new SqlParameter("@contractSubVersionNumber", contractSubVersionNumber),
                    new SqlParameter("@createdDate", createdDate)};

                    context.Database.ExecuteSqlCommand("dbo.sp_AddCreatedContractOrUpdate @contractNumber,@contractVersionNumber,@contractSubVersionNumber,@createdDate", parameters);

                }
            }
        }

        public static bool IsCreatedContractPresent(string contractNumber, int contractVersionNumber, int contractSubVersionNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                bool result = (from cc in context.CreatedContracts
                               where cc.ContractNumber == contractNumber
                              && cc.ContractVersionNumber == contractVersionNumber && cc.ContractVersionNumber == contractVersionNumber
                              && cc.ContractSubVersionNumber == contractSubVersionNumber
                               select cc).Count() == 1;
                return result;
            }
        }

        public static void UpdateCreatedContractCreatedDate(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, DateTime createdDate)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_UpdateCreatedContractCreatedDate @createdDate,@contractNumber,@contractVersionNumber,@contractSubVersionNumber", new { createdDate, contractNumber, contractVersionNumber, contractSubVersionNumber });

            }
        }
    }
}
