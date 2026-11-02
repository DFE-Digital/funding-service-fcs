namespace FCT.Console.Config.Tests.Exploratory
{
    using System;
    using System.Diagnostics;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.CRM;
    using UnitTests.Common;

    [TestClass]
    public class CrmDeliverableSynchronizerExploratoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldRunCrmDeliverableSynchronizer()
        {
            CrmDeliverableSynchronizer synchronizer = new CrmDeliverableSynchronizer();

            using (TestResource resource =
                new TestResource("FCT.Console.Config.Tests", @"Resources.FundingStreamConfigData.xlsx"))
            {
                WorkbookReader workbookReader = new WorkbookReader(resource.Stream);
                IWorksheetReader worksheetReader = workbookReader.WorksheetReader("Deliverable");

                Stopwatch sw = new Stopwatch();
                sw.Start();

                synchronizer.AddOrUpdateConfig(worksheetReader);

                sw.Stop();

                Console.WriteLine($"Elapsed time: {sw.Elapsed.TotalSeconds}");
            }
        }
    }
}
