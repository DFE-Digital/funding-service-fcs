namespace FCT.Operations
{
    using System.IO;

    public static class LicenseManager
    {
        private const string AsposeLicenseResourceName = "FCT.Operations.Resources.Aspose.Total.lic";

        public static Stream GetAsposeLicense()
        {
            return typeof(LicenseManager).Assembly.GetManifestResourceStream(AsposeLicenseResourceName);
        }
    }
}
