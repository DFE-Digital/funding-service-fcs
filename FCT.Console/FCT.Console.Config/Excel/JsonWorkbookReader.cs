namespace FCT.Console.Config.Excel
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Newtonsoft.Json.Linq;

    public class JsonWorkbookReader : IWorkbookReader
    {
        private readonly JObject _parentJObject;

        public JsonWorkbookReader(Stream fileStream)
        {
            var streamReader = new StreamReader(fileStream);
            _parentJObject = JObject.Parse(streamReader.ReadToEnd());
        }

        public IReadOnlyCollection<string> SheetNames()
        {
            return _parentJObject.Properties().Select(p => p.Name).ToList();
        }

        public IWorksheetReader WorksheetReader(string workSheetName)
        {
            var sheet = _parentJObject[workSheetName] as JArray;
            
            return new JsonWorksheetReader(sheet);
        }
    }
}
