namespace FCT.Console.Config.Templates.Repositories
{
    using System.Linq;
    using System.IO;
    using System.Reflection;
    using System.Collections.Generic;

    public class AssemblyRepository : IAssemblyRepository
    {
        public IEnumerable<string> GetFilenamesToUpload()
        {
            const string folderName = "FCT.Console.Config.Resources.DocumentTemplates.";

            return Assembly.GetExecutingAssembly()
                .GetManifestResourceNames()
                .Where(r => r.StartsWith(folderName) && r.EndsWith(".docx"))
                .Select(r => r.Replace(folderName, string.Empty))
                .ToList();
        }

        public byte[] GetTemplateDocumentToUpload(string fileName)
        {
            const string folderName = "FCT.Console.Config.Resources.DocumentTemplates.";

            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream($"{folderName}{fileName}"))
            {
                var memoryStream = new MemoryStream();
                stream.CopyTo(memoryStream);

                return memoryStream.ToArray();
            }
        }
    }
}