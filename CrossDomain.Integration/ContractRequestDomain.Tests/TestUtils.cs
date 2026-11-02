namespace ContractRequestDomain.Tests
{
    using System;
    using System.Globalization;
    using System.IO;
    using UnitTests.Common;

    internal static class TestUtils
    {
        internal static byte[] FileToByteArray(string filepath)
        {
            using (FileStream fs = new FileStream(filepath, FileMode.Open, FileAccess.Read))
            {
                BinaryReader br = new BinaryReader(fs);
                long numBytes = new FileInfo(filepath).Length;
                return br.ReadBytes((int)numBytes);
            }
        }

        internal static byte[] FileToByteArray(Stream stream)
        { 
            using (var ms = new MemoryStream())
            {
                stream.CopyTo(ms);
                return ms.ToArray();
            }
        }

        internal static byte[] ResourceToByteArray(string baseNamespace, string resourceName)
        {
            using (TestResource resource = new TestResource(baseNamespace, resourceName))
            {
                return FileToByteArray(resource.Stream);
            }
        }
        
        public static DateTime GetUtcDateTime(string dateValue)
        {
            DateTime dt = DateTime.MinValue;
            if (dateValue != null)
            {
                DateTime.TryParseExact(dateValue, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out dt);
            }
            return dt.ToUniversalTime();
        }
    }
}
