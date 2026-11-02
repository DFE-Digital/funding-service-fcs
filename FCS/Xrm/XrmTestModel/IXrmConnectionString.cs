
namespace XrmTestModel
{
    using System.Collections.Generic;

    public interface IXrmConnectionString
    {
        Dictionary<string, string> ConnectionStringDictionary { get; set; }

    }
}
