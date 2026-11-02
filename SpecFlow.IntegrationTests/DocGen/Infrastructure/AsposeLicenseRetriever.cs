namespace DocGenTests.Infrastructure
{
    using System.IO;

    public static class AsposeLicenseRetriever
    {
        private const string AsposeLicenseResourceName = "DocGenTests.Infrastructure.Aspose.Total.lic";

        public static Stream GetStreamToLicense()
        {
            return typeof(AsposeLicenseRetriever).Assembly.GetManifestResourceStream(AsposeLicenseResourceName);
        }
    }
}
