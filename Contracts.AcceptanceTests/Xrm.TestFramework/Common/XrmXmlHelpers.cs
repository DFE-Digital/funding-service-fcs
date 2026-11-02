// <copyright file="XrmXmlHelpers.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Xml;
    using System.Xml.XPath;

    /// <summary>
    /// Static XrmHelpers Class - used for common methods for parsing Xml
    /// </summary>
    public static class XrmXmlHelpers
    {
        /// <summary>
        /// Method for parsing a boolean value from an entity document
        /// </summary>
        /// <param name="xmlDocument">Xml Document to be parsed</param>
        /// <param name="nodeName">The node to be selected</param>
        /// <returns>True if the node is set to 0, otherwise false</returns>
        public static bool GetBoolValueFromEntityNode(IXPathNavigable xmlDocument, string nodeName)
        {
            var returnValue = false;

            XPathNavigator navigator = xmlDocument.CreateNavigator();

            var node = navigator.SelectSingleNode(nodeName);

            if (node != null)
            {
                int nodeValue;
                bool boolValue;
                if (bool.TryParse(node.Value, out boolValue))
                {
                    returnValue = boolValue;
                }
                else if (int.TryParse(node.Value, out nodeValue))
                {
                    returnValue = nodeValue != 0;
                }
            }

            return returnValue;
        }

        public static string GetStringValueFromXmlNode(XmlNode xmlNode, string nodeName)
        {
            var returnValue = string.Empty;

            var node = xmlNode.SelectSingleNode(nodeName);
            if (node != null)
            {
                returnValue = node.InnerText;
            }

            return returnValue;
        }

        /// <summary>
        /// Method for parsing a boolean value from a form control node
        /// </summary>
        /// <param name="node">The form control node</param>
        /// <returns>True if the node is set to enabled, false otherwise</returns>
        public static bool GetEnabledFromFormNode(XmlNode node)
        {
            if (node.Attributes["disabled"] == null)
            {
                return true;
            }
            else
            {
                var textValue = node.Attributes["disabled"].InnerText;
                bool value;

                bool.TryParse(textValue, out value);

                return !value;
            }
        }
    }
}
