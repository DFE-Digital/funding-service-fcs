namespace FCT.Operations.Tests
{
    using System.IO;

    public class LicenseManager
    {
        private const string AsposeLicenseResourceName = "FCT.Operations.Tests.Resources.Aspose.Total.lic";

        public static Stream GetAsposeLicense()
        {
            return typeof(LicenseManager).Assembly.GetManifestResourceStream(AsposeLicenseResourceName);
        }
    }
}