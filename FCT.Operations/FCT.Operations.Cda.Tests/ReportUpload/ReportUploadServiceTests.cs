namespace FCT.Operations.Cda.Tests.ReportUpload
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Cda.ReportUpload;
    using FCT.Operations.Cda.Dtos;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReportUploadServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ReportUploadService_ShouldUpload()
        {
            // arrange
            const string fileName = "Test.csv";
            var config = new LocalConfig();

            var fileLines = LinesFromText("FCT.Operations.Cda.Tests",
                "TestResources.CDA Last Approved Version 16-19 Funding 17-18.csv");

            Assert.IsTrue(fileLines.Count > 0);
            
            // convert the lines to CDA Rows
            var cdaRows = fileLines.Skip(1).Select(f =>
            {
                var cols = f.Split(',');
                return new CdaRow
                {
                    FundingStreamPeriodCode = cols[0]
                };
            }).ToList();

            var office365Wrapper = new Office365StorageWrapper(config, Mock.Of<ILogger>(),
                new AuthenticationHelper(new SharepointOAuthAccessTokenFactory(config)));

            var service = new ReportUploadService(office365Wrapper, config);

            // act
            service.UploadReportToSharePoint(new Report(cdaRows, fileName));

            // assert
            var linesInUploadedFile = GetFileLinesOfUploadedFile(office365Wrapper, fileName);

            Assert.AreEqual(fileLines.Count, linesInUploadedFile.Count);
        }

        private IList<string> GetFileLinesOfUploadedFile(Office365StorageWrapper office365StorageWrapper, string fileName)
        {
            string reportFolder = ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"];
            var bytes = office365StorageWrapper.GetFileContents(fileName, reportFolder);
            string csvString = System.Text.Encoding.UTF8.GetString(bytes);

            return csvString.Split(new[] { Environment.NewLine }, StringSplitOptions.None)
                .Where(l => !string.IsNullOrEmpty(l)).ToList();
        }

        private static IReadOnlyCollection<string> LinesFromText(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                List<string> lines = new List<string>();

                while (!streamReader.EndOfStream)
                {
                    lines.Add(streamReader.ReadLine());
                }

                return lines;
            }
        }

        private class LocalConfig : IFcsConfiguration
        {
            public string this[string key]
            {
                get
                {
                    var configConnectionString = ConfigurationManager.ConnectionStrings[key];
                    if (configConnectionString != null)
                    {
                        return configConnectionString.ConnectionString;
                    }

                    return ConfigurationManager.AppSettings[key];
                }
            }
        }
    }
}
