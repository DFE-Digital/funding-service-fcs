namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public static class DocumentsDomainContractDocumentTemplateWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<ContractDocumentTemplateSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearDocumentTemplateTable(context);

                var writer =
                    new ConfigWriter<ContractDocumentTemplateSheetType, ContractDocumentTemplate>(context, context.ContractDocumentTemplates);

                writer.Write(rows, TypeTransformer.TransformCollection<ContractDocumentTemplateSheetType, ContractDocumentTemplate>, GetKeyDocumentTemplate, behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKeyDocumentTemplate(ContractDocumentTemplate entity)
        {
            return new object[]
            {
                entity.FundingTypeCode,
                entity.FundingPeriodCode,
                entity.DocumentComponentCode,
                entity.ContractType
            };
        }

        private static void ClearDocumentTemplateTable(DocumentsDomainDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [DocumentsDomain].[ContractDocumentTemplate]";

            context.ExecuteSql(deleteSqlCommand);
        }
    }
}
