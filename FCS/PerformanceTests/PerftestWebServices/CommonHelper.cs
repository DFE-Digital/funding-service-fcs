using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;

namespace SFA.FCT.PerformanceTests
{
    public class CommonHelper
    {
        public XmlDocument CreatePayloadXML(String filePath)
        {
            XmlDocument xml = new XmlDocument();
            xml.Load(filePath);
            return xml;
        }
    }
}
