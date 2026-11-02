namespace FCT.Console.Config.Templates.Extensions
{
    using System.Linq;
    using System.Security.Cryptography;

    public static class ByteArrayExtensions
    {
        public static byte[] GetTemplateDocumentToUploadChecksum(this byte[] stream)
        {
            using (var md5 = MD5.Create())
            {
                return md5.ComputeHash(stream);
            }
        }

        public static bool TemplateDocumentHasNotAlreadyBeenAdded(this byte[] existingTemplateDocumentCheckSum)
        {
            return existingTemplateDocumentCheckSum == null;
        }

        public static bool ChecksumsAreNotTheSame(this byte[] first, byte[] second)
        {
            return !first.SequenceEqual(second);
        }
    }
}