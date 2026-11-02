namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.IO;
    using System.Reflection;

    public class ResourceManager
    {
        private const string EmbeddedResourceNameSpace = "SFA.FCT.Contracts.AcceptanceTests.Resources";

        public static byte[] GetEmbeddedResourceAsBytes(string resourceFileName)
        {
            Assembly assembly = Assembly.GetExecutingAssembly();

            using (Stream resourceFileStream = assembly.GetManifestResourceStream($"{EmbeddedResourceNameSpace}.{resourceFileName}"))
            {
                byte[] ba = new byte[resourceFileStream.Length];
                resourceFileStream.Read(ba, 0, ba.Length);

                return ba;
            }
        }
    }
}
