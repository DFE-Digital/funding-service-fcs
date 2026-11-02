namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.IO;

    public static class LicenseManager
    {
        private const string AsposeLicenseResourceName = "SFA.FCT.CrossDomain.Integration.Common.Aspose.Total.lic";

        public static Stream GetAsposeLicense()
        {
            return typeof(LicenseManager).Assembly.GetManifestResourceStream(AsposeLicenseResourceName);
        }
    }
}
