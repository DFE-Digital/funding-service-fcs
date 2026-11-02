namespace XrmTestModel
{
    using System.Collections.Generic;

    public class XrmConnectionString : IXrmConnectionString
    {
        public Dictionary<string, string> ConnectionStringDictionary { get; set; }
    }
}
