
namespace FCT.Operations.Tests.Repositories
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using FCT.Operations.Repositories;
    using FluentAssertions;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class WorkbookSharePointRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookSharePointRepository_ShouldUploadToSharePoint()
        {
            const string filename = "2020-10 Payments.xlsx";
            const string foldername = "Consolidated Payment Summary"; // Document library display name

            // arrange
            var configuration = AppConfiguration.Configuration();

            var configAdapter = new FcsConfig(configuration);
            var tokenFactory = new SharepointOAuthAccessTokenFactory(configAdapter);
            var authHelper = new AuthenticationHelper(tokenFactory);

            // ILogger can be your real logger or a mock; keeping the mock preserves test isolation
            var office365Wrapper = new Office365StorageWrapper(
                configAdapter,
                Mock.Of<ILogger>(),
                authHelper);

            // Ensure the target document library exists in the site (Graph-only wrapper supports this)
            if (!office365Wrapper.DoesFolderExist(foldername))
            {
                // In your Graph wrapper, CreateFolder(string) creates a new document library
                office365Wrapper.CreateFolder(foldername);
            }

            // If the file exists from a prior run, remove it to ensure a clean test
            if (office365Wrapper.DoesFileExist(foldername, filename))
            {
                office365Wrapper.DeleteFile(filename, foldername);
            }

            // Read embedded workbook content from test resources
            byte[] fileBytes = AsBytes("FCT.Operations.Tests.Resources", "2020-10 Payments.xlsx");

            var repository = new WorkbookSharePointRepository(office365Wrapper);

            // act
            repository.Upload(foldername, filename, fileBytes);

            // assert
            bool doesFileExistInSharePoint = office365Wrapper.DoesFileExist(foldername, filename);
            doesFileExistInSharePoint.Should().BeTrue("the uploaded workbook should be present in the target document library");
        }

        /// <summary>
        /// Loads an embedded resource from this test assembly into memory as bytes.
        /// </summary>
        private static byte[] AsBytes(string resourceNamespace, string resourceName)
        {
            var assembly = typeof(WorkbookSharePointRepositoryTests).Assembly;
            var fullName = resourceNamespace + "." + resourceName;

            using (Stream stream = assembly.GetManifestResourceStream(fullName))
            {
                if (stream == null)
                {
                    // Help diagnose missing resource name/embedding issues quickly
                    var available = assembly.GetManifestResourceNames();
                    var hint = string.Join(Environment.NewLine + " - ", available.Select(n => n));
                    throw new FileNotFoundException(
                        $"Embedded resource '{fullName}' not found. Available resources:{Environment.NewLine} - {hint}");
                }

                using (var ms = new MemoryStream())
                {
                    stream.CopyTo(ms);
                    return ms.ToArray();
                }
            }
        }

        /// <summary>
        /// Small adapter for IConfigurationRoot to IFcsConfiguration used by your infrastructure constructors.
        /// </summary>
        private class FcsConfig : IFcsConfiguration
        {
            private readonly IConfigurationRoot _configurationRoot;

            public FcsConfig(IConfigurationRoot configurationRoot)
            {
                _configurationRoot = configurationRoot;
            }

            public string this[string key] => _configurationRoot[key];
        }
    }
}
