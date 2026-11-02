namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public class DocumentsDomainContractReferenceConfigWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ContractReferenceDataSheet> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                var writer = new ConfigWriter<ContractReferenceDataSheet, ContractReferenceConfig>(context,
                        context.ContractReferenceConfigs);

                writer.Write(rows,
                    TypeTransformer
                        .TransformCollection<ContractReferenceDataSheet, ContractReferenceConfig>,
                    GetKey, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKey(ContractReferenceConfig entity) => new object[] { entity.Ukprn, entity.FundingStreamPeriodCode };
    }
}