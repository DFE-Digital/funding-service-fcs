namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public class ContractManagementFundingTypeFundingPeriodContractTypeWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<FTPCoTSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearFundingTypeFundingPeriodContractTypeTable(context);

                ConfigWriter<FTPCoTSheetType, FundingTypeFundingPeriodContractType> writer =
                    new ConfigWriter<FTPCoTSheetType, FundingTypeFundingPeriodContractType>(context,
                        context.FundingTypeFundingPeriodContractTypes);

                writer.Write(rows,
                    TypeTransformer.TransformCollection<FTPCoTSheetType, FundingTypeFundingPeriodContractType>,
                    GetKeyFundingTypeFundingPeriodContractType,
                    behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKeyFundingTypeFundingPeriodContractType(FundingTypeFundingPeriodContractType entity)
        {
            return new object[]
            {
                entity.FundingTypeCode,
                entity.FundingPeriodCode,
                entity.ContractType
            };
        }

        private static void ClearFundingTypeFundingPeriodContractTypeTable(IContractManagementDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [ContractManagement].[FundingTypeFundingPeriodContractType]";

            context.ExecuteSql(deleteSqlCommand);
        }
    }
}