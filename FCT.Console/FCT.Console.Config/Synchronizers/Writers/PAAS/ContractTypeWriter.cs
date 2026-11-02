namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;

    public static class ContractTypeWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ContractTypeSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<ContractTypeSheetType, ContractType> writer =
                    new ConfigWriter<ContractTypeSheetType, ContractType>(context, context.ContractTypes);

                writer.Write(rows, Transformer, GetKeyForContractType, behaviour);
                context.SaveChanges();
            }
        }

        private static IEnumerable<ContractType> Transformer(IEnumerable<ContractTypeSheetType> toTransform)
        {
            return toTransform.Select(t => new ContractType(t.ContractType));
        }

        private static object[] GetKeyForContractType(ContractType contractTypeModel)
        {
            return new object[]
            {
                contractTypeModel.ContractTypeName
            };
        }
    }
}
