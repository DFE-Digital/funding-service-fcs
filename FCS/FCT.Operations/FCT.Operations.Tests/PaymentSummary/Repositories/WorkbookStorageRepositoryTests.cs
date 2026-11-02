namespace FCT.Operations.Tests.PaymentSummary.Repositories
{
    using System.IO;
    using System.Reflection;
    using Aspose.Cells;
    using FluentAssertions;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary.Repositories;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class WorkbookStorageRepositoryTests
    {
        private const string ContainerRootName = "fcs-payment-report";

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookStorageRepository_ShouldUpload()
        {
            // arrange
            SetupAsposeLicence();
            const string fileName = "uploadTestWorkbook.xlsx";
            IConfigurationRoot configuration = AppConfiguration.Configuration();
            AzureStorageRepository.Delete(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration));

            var repository = new WorkbookStorageRepository(new FcsConfig(configuration));

            // act
            repository.Upload(GetWorkbookFromResource(), fileName);

            // assert
            var blob = AzureStorageRepository.GetBlockBlob(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration));
            Assert.IsNotNull(blob);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookStorageRepository_ShouldDetermineWhenFileExists()
        {
            // arrange
            SetupAsposeLicence();
            const string fileName = "uploadTestWorkbook.xlsx";

            var bytes = ConvertToMemoryStream(GetWorkbookFromResource()).ToArray();
            IConfigurationRoot configuration = AppConfiguration.Configuration();

            AzureStorageRepository.Delete(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration));
            AzureStorageRepository.PutBlockBlob(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration), bytes);
            
            var repository = new WorkbookStorageRepository(new FcsConfig(configuration));

            // act
            bool doesFileExist = repository.Exists(fileName);

            // assert
            doesFileExist.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookStorageRepository_ShouldDetermineWhenFileDoesNotExists()
        {
            // arrange
            SetupAsposeLicence();
            const string fileName = "uploadTestWorkbook.xlsx";

            IConfigurationRoot configuration = AppConfiguration.Configuration();
            AzureStorageRepository.Delete(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration));
            var repository = new WorkbookStorageRepository(new FcsConfig(configuration));

            // act
            bool doesFileExist = repository.Exists(fileName);

            // assert
            doesFileExist.Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookStorageRepository_ShouldGetWorkbookBytes()
        {
            const string fileName = "uploadTestWorkbook.xlsx";

            // arrange
            SetupAsposeLicence();

            byte[] uploadBytes = ConvertToMemoryStream(GetWorkbookFromResource()).ToArray();
            IConfigurationRoot configuration = AppConfiguration.Configuration();

            AzureStorageRepository.Delete(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration));
            AzureStorageRepository.PutBlockBlob(GetAzureStorageConnectionString(configuration), fileName, GetContainerName(configuration), uploadBytes);
            

            WorkbookStorageRepository repository = new WorkbookStorageRepository(new FcsConfig(configuration));

            // act
            byte[] fileBytes = repository.GetWorkbookBytes(fileName);

            // assert
            fileBytes.Should().NotBeNull("returned bytes should be non-null");
            fileBytes.Should().HaveCount(uploadBytes.Length, "returned bytes should be same length as input bytes");
        }

        private static void SetupAsposeLicence()
        {
            using (var licenseStream = LicenseManager.GetAsposeLicense())
            {
                var license = new License();
                license.SetLicense(licenseStream);
            }
        }

        private static Workbook GetWorkbookFromResource()
        {
            return new Workbook(Assembly.GetExecutingAssembly().GetManifestResourceStream("FCT.Operations.Tests.Resources.PaymentSummaryTemplate.xlsx"));
        }
        
        private static string GetEnvironmentSuffix(IConfigurationRoot configuration)
        {
            var environment = configuration["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }
            return environment;
        }

        private static MemoryStream ConvertToMemoryStream(Workbook workbook)
        {
            var memoryStream = new MemoryStream();

            workbook.Save(memoryStream, (SaveFormat)workbook.FileFormat);
            return memoryStream;
        }

        private static string GetAzureStorageConnectionString(IConfigurationRoot configuration) => configuration["ConnectionStrings:StorageConnectionString"];

        private static string GetContainerName(IConfigurationRoot configuration) => $"{ContainerRootName}{GetEnvironmentSuffix(configuration)}";

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