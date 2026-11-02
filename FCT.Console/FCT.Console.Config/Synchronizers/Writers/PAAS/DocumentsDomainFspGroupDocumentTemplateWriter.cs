namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using SFA.FCT.DocumentsDomain.DataStore;
    using Transformers;

    public static class DocumentsDomainFspGroupDocumentTemplateWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<FspGroupDocumentTemplateSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
               ClearDocumentTemplateTable(context);

                ConfigWriter<FspGroupDocumentTemplateSheetType, FspGroupDocumentTemplate> writer =
                    new ConfigWriter<FspGroupDocumentTemplateSheetType, FspGroupDocumentTemplate>(context, context.FspGroupDocumentTemplates);

                writer.Write(rows, TypeTransformer.TransformCollection<FspGroupDocumentTemplateSheetType, FspGroupDocumentTemplate>, GetKeyDocumentTemplate, behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKeyDocumentTemplate(FspGroupDocumentTemplate entity)
        {
            return new object[]
            {
                entity.FundingTypeCode,
                entity.FundingPeriodCode,
                entity.DocumentComponentCode,
                entity.FSPGroupCode,
                entity.ContractType
            };
        }

        private static void ClearDocumentTemplateTable(DocumentsDomainDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [DocumentsDomain].[FspGroupDocumentTemplate]";

            context.ExecuteSql(deleteSqlCommand);
        }
    }
}