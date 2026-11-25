using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OrganisationDomain.Implementation.Converters
{
    public interface IPimsJsonToProviderXmlConverter
    {
        XDocument Convert(string json);

    }
}
