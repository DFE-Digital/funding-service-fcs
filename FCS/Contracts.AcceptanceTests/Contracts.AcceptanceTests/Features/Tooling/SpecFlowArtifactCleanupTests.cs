namespace SFA.FCT.Contracts.AcceptanceTests.Features.Tooling
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Text.RegularExpressions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SpecFlowArtifactCleanupTests
    {
        private const string AcceptanceTestsProjectPath = @"E:\SFA\Source\Git\FCS\Contracts.AcceptanceTests\Contracts.AcceptanceTests\Contracts.AcceptanceTests.csproj";
        private const string FeatureFileDirectory = @"E:\SFA\Source\Git\FCS\Contracts.AcceptanceTests\Contracts.AcceptanceTests\Features";
        private const string StepFileDirectory = @"E:\SFA\Source\Git\FCS\Contracts.AcceptanceTests\Contracts.AcceptanceTests\Steps";
        private const string DataFileDirectory = @"E:\SFA\Source\Git\FCS\Contracts.AcceptanceTests\Contracts.AcceptanceTests\DataFiles";

        [TestMethod, TestCategory("Tooling")]
        public void ShouldFindNoUnusedSpecFlowStepExpressions()
        {
            const string seleniumBypassStepExpression = "via SDK";

            string[] featureFileContents = GetFeatureFileContents(FeatureFileDirectory);
            StepInfo[] steps = GetStepInfos(StepFileDirectory);

            string allTheGherkin = string.Join(Environment.NewLine, featureFileContents);

            StepInfo[] unmatchedSteps = steps
                .Where(s => !new Regex(s.Expression).Match(allTheGherkin).Success)
                .Where(s => !s.Expression.Contains(seleniumBypassStepExpression))
                .ToArray();

            Assert.AreEqual(0, unmatchedSteps.Length, Environment.NewLine + string.Join(Environment.NewLine, unmatchedSteps.Select(s => $"{s.Filename}: {s.Expression}")));
        }

        [TestMethod, TestCategory("Tooling")]
        public void ShouldFindNoUnreferencedFeatureFiles()
        {
            string[] featureFilePaths = GetFeatureFilePaths(FeatureFileDirectory);

            string acceptanceTestsProjectContent = File.ReadAllText(AcceptanceTestsProjectPath);

            string[] unreferencedFeatureFiles = featureFilePaths.Where(f => !acceptanceTestsProjectContent.Contains(Path.GetFileName(f))).ToArray();

            Assert.AreEqual(0, unreferencedFeatureFiles.Length, Environment.NewLine + string.Join(Environment.NewLine, unreferencedFeatureFiles));
        }

        [TestMethod, TestCategory("Tooling")]
        public void ShouldFindNoUnreferencedStepFiles()
        {
            string[] stepFilePaths = GetStepFilePaths(StepFileDirectory);

            string acceptanceTestsProjectContent = File.ReadAllText(AcceptanceTestsProjectPath);

            string[] unreferencedStepFiles = stepFilePaths.Where(f => !acceptanceTestsProjectContent.Contains(Path.GetFileName(f))).ToArray();

            Assert.AreEqual(0, unreferencedStepFiles.Length, Environment.NewLine + string.Join(Environment.NewLine, unreferencedStepFiles));
        }

        [TestMethod, TestCategory("Tooling")]
        public void ShouldFindNoUnusedBulkImportFiles()
        {
            string[] bulkImportFilenames = GetBulkImportFilenames(DataFileDirectory);
            string[] featureFileContents = GetFeatureFileContents(FeatureFileDirectory);

            string allTheGherkin = string.Join(Environment.NewLine, featureFileContents);

            string[] unusedBulkImportFiles = bulkImportFilenames.Where(fn => !allTheGherkin.Contains(fn)).ToArray();

            Assert.AreEqual(0, unusedBulkImportFiles.Length, Environment.NewLine + string.Join(Environment.NewLine, unusedBulkImportFiles));
        }

        private static string[] GetFeatureFileContents(string directory)
        {
            return
                Directory.EnumerateFiles(directory, "*.feature", SearchOption.AllDirectories)
                .Select(File.ReadAllText)
                .ToArray();
        }

        private static string[] GetFeatureFilePaths(string directory)
        {
            return
                Directory.EnumerateFiles(directory, "*.feature", SearchOption.AllDirectories)
                .ToArray();
        }

        private static StepInfo[] GetStepInfos(string directory)
        {
            return
                Directory.EnumerateFiles(directory, "*.cs", SearchOption.AllDirectories)
                .SelectMany(path => ExtractExpressions(File.ReadAllLines(path)).Select(exp => new StepInfo(Path.GetFileNameWithoutExtension(path), exp)))
                .ToArray();
        }

        private static string[] GetStepFilePaths(string directory)
        {
            return
                Directory.EnumerateFiles(directory, "*.cs", SearchOption.AllDirectories)
                .ToArray();
        }

        private static string[] GetBulkImportFilenames(string directory)
        {
            return
                Directory.EnumerateFiles(directory, "*.xlsx", SearchOption.AllDirectories)
                    .Select(Path.GetFileNameWithoutExtension)
                    .ToArray();
        }

        private static string[] ExtractExpressions(string[] lines)
        {
            return lines
                .Where(s => s.Contains("[Given(") || s.Contains("[When(") || s.Contains("[Then("))
                .Where(s => s.Contains('"'))
                .Select(s => s.Substring(s.IndexOf('"') + 1, s.LastIndexOf('"') - s.IndexOf('"') - 1))
                .ToArray();
        }

        private class StepInfo
        {
            public StepInfo(string filename, string expression)
            {
                Filename = filename;
                Expression = expression;
            }

            public string Filename { get; }

            public string Expression { get; }
        }
    }
}
