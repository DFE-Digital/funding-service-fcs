namespace Datafix.Tests.Automation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Operations.DataStore.Model;
    using Repositories;

    [TestClass]
    public class ApplyNewDataFixes
    {
        private readonly IDataFixHistoryRepository _dataFixHistoryRepository = new DataFixHistoryRepository();   // Mock.Of<IDataFixHistoryRepository>();

        [TestMethod, TestCategory("DataFixes_Automated")]
        public void ApplyNewDataFixes_RunDataFixes()
        {
            // find all classes that implement the IApplyDataFix interface
            List<IApplyDataFix> dataFixes = GetDataFixTypes().Select(CreateInstance).ToList();
            Console.WriteLine($@"Found dataFixes: { dataFixes.Count}");

            IReadOnlyCollection<DataFixHistory> existingDataFixes = DataFixHistoryRepository.GetAll();
            Console.WriteLine($@"ExistingDataFixes: { existingDataFixes.Count}");

            var existingKeys = existingDataFixes.Select(existingDf => existingDf.GetKey()).ToList();

            var dataFixesToRun = dataFixes.Where(df => !existingKeys.Contains(GetKey(df))).ToList();
            Console.WriteLine($@"DataFixesToRun: { dataFixesToRun.Count}");

            var numReleases = dataFixesToRun.Select(d => d.Release.ToUpper()).Distinct().Count();

            Assert.IsTrue(numReleases < 2, "We have more than one 'release' in our datafixes");

            dataFixesToRun.OrderBy(d => d.Order).ToList().ForEach(RunDataFix);
        }

        private void RunDataFix(IApplyDataFix dataFix)
        {
            Console.WriteLine($@"ApplyDataFix: { dataFix.Name}");
            dataFix.ApplyDataFix();
            Console.WriteLine($@"Completed ApplyDataFix: { dataFix.Name}");

          _dataFixHistoryRepository.Add(dataFix.ToDataFixHistory()).Wait();
        }

        private IEnumerable<Type> GetDataFixTypes()
        {
            Type iApplyDataFix = typeof(IApplyDataFix);

            return System.Reflection.Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(t => t.GetInterfaces().Contains(iApplyDataFix))
                .ToList();
        }

        private static IApplyDataFix CreateInstance(Type type)
        {
            return (IApplyDataFix)Activator.CreateInstance(type);
        }

        private static string GetKey(IApplyDataFix dataFix)
        {
            return $"{dataFix.Release}{dataFix.StoryNumber}{dataFix.Name}".ToUpper();
        }
    }
}
