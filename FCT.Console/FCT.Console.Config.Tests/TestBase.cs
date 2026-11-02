namespace FCT.Console.Config.Tests
{
    using Excel;
    using System.Data.Entity;
    using Config.Excel;
    using UnitTests.Common;

    public class TestBase
    {
        public static WorkbookReader WorkbookReader { get; set; }
        public static JsonWorkbookReader JsonWorkbookReader { get; set; }

        public WorkbookReader GetWorkbookReader()
        {
            if (WorkbookReader == null)
            {
                using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.FundingStreamConfigData.xlsx"))
                {
                    WorkbookReader = new WorkbookReader(resource.Stream);
                }
            }

            return WorkbookReader;
        }

        public JsonWorkbookReader GetJsonWorkbookReader()
        {
            if (JsonWorkbookReader == null)
            {
                using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
                {
                    JsonWorkbookReader = new JsonWorkbookReader(resource.Stream);
                }
            }

            return JsonWorkbookReader;
        }

        protected void RemoveEntity<TEntity>(IDbSet<TEntity> dbset, object[] primaryKey) where TEntity : class
        {
            var entity = dbset.Find(primaryKey);

            if (entity != null)
            {
                dbset.Remove(entity);
            }
        }
    }
}
