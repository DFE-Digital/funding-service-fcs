// <copyright file="XrmPackageForm.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using System.Web;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageForm
    ///   Description:    Class for handling the FormXml for an entity form as defined by a Dynamics CRM Solution
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class for handling the FormXml for an entity form as defined by a Dynamics CRM Solution
    /// </summary>
    public class XrmPackageForm
    {
        #region Fields

        /// <summary>
        /// An array of XmlPackageAttribute fields
        /// </summary>
        private List<XrmPackageAttribute> fields;

        private List<XrmFormTab> tabs;

        #endregion

        #region Constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageForm"/> class
        /// </summary>
        /// <param name="formXmlDoc">XML Document containing the form definition</param>
        /// <param name="formType">The form type - "main" or "mobile"</param>
        public XrmPackageForm(string entityLogicalName, XmlDocument formXmlDoc, string formType)
        {
            this.EntityLogicalName = entityLogicalName;

            this.FormType = formType;

            this.FormName = formXmlDoc.SelectSingleNode(@"//systemform/LocalizedNames/LocalizedName[@languagecode=""1033""]").Attributes["description"].Value;

            try
            {
                this.FormId = formXmlDoc.SelectSingleNode(@"//systemform/formid").InnerText.ToUpperInvariant().Replace("{", "").Replace("}", string.Empty);
            }
            catch
            {
            }

            List<XrmFormTab> formTabs = new List<XrmFormTab>();

            List<XrmPackageAttribute> formAttributes = new List<XrmPackageAttribute>();

            var locations = new string[] { "tabs/tab", "header/rows/row", "footer/rows/row" };

            foreach (var location in locations)
            {
                // Loop through XML Nodes identified as having controls bound to a data field name
                foreach (XmlNode tab in formXmlDoc.SelectNodes("//systemform/form/" + location))
                {
                    XrmFormTab formTab = new XrmFormTab();

                    formTab.Name = (tab.Attributes["name"] == null) ? "" : tab.Attributes["name"].Value;
                    var label = tab.SelectSingleNode(@"labels/label[@languagecode=""1033""]");

                    formTab.DisplayName = (label == null) ? string.Empty : (label.Attributes["description"] == null) ? string.Empty : label.Attributes["description"].Value;

                    List<XrmPackageAttribute> controls = new List<XrmPackageAttribute>();

                    // Loop through XML Nodes identified as having controls bound to a data field name
                    foreach (XmlNode c in tab.SelectNodes(".//cell[control[not(@datafieldname)]]"))
                    {
                        XmlNode controlNode = c.SelectSingleNode("./control");
                        if (controlNode != null)
                        {
                            XmlNode lookupNode = c.SelectSingleNode("./control/parameters");
                            if (lookupNode != null)
                            {
                                string ViewId = string.Empty;
                                XmlNode viewIdNode = lookupNode.SelectSingleNode("ViewId");
                                if (viewIdNode != null)
                                {
                                    ViewId = viewIdNode.InnerText;

                                    controls.Add(new XrmPackageAttribute(ViewId, XrmXmlHelpers.GetEnabledFromFormNode(c), lookupNode, ViewId));
                                }
                            }
                        }
                    }
                    formTab.Controls = controls;

                    formTabs.Add(formTab);

                    List<XrmPackageAttribute> tabAttributes = new List<XrmPackageAttribute>();

                    // Loop through XML Nodes identified as having controls bound to a data field name
                    foreach (XmlNode c in tab.SelectNodes(".//cell[control[@datafieldname]]"))
                    {
                        XmlNode controlNode = c.SelectSingleNode("./control");
                        XmlNode lookupNode = c.SelectSingleNode("./control/parameters");
                        string controlLabel = c.SelectSingleNode(@"./labels/label[@languagecode=""1033""]").Attributes["description"].Value;
                        string quickFormId = string.Empty;

                        if (lookupNode != null)
                        {
                            XmlNode quickFormsNode = lookupNode.SelectSingleNode("QuickForms");

                            if (quickFormsNode != null)
                            {
                                string qfhtml = quickFormsNode.InnerText; // stored as html
                                string qf = HttpUtility.HtmlDecode(qfhtml);
                                XmlDocument xmlDocument = new XmlDocument();
                                xmlDocument.LoadXml(qf);

                                XmlNode quickFormIdNode = xmlDocument.SelectSingleNode("//QuickFormId");
                                if (quickFormIdNode != null)
                                {
                                    quickFormId = quickFormIdNode.InnerText.ToUpperInvariant();
                                }
                            }
                        }

                        tabAttributes.Add(new XrmPackageAttribute(controlNode.Attributes["datafieldname"].Value, XrmXmlHelpers.GetEnabledFromFormNode(controlNode), lookupNode, controlLabel, quickFormId));
                    }

                    formTab.Attributes = tabAttributes;

                    formAttributes.AddRange(tabAttributes);
                }
            }

            this.fields = formAttributes;

            this.tabs = formTabs;
        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets a value representing the form name
        /// </summary>
        public string FormName { get; private set; }

        /// <summary>
        /// Gets a value representing the form type - currently "main" or "mobile"
        /// </summary>
        public string FormType { get; private set; }
        public string EntityLogicalName { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string FormId { get; private set; }

        #endregion

        #region Methods
        /// <summary>
        /// Get a field from the form definition
        /// </summary>
        /// <param name="fieldName">The field logical name (datafieldname) from the form definition</param>
        /// <returns>The XrmPackageAttribute corresponding to this field</returns>
        public XrmPackageAttribute Field(string fieldName)
        {
            var fieldMatch = from f in this.fields where f.LogicalName == fieldName select f;

            if (!fieldMatch.Any())
            {
                fieldMatch = from f in this.fields where f.displayName == fieldName select f;
            }

            Assert.IsTrue(fieldMatch.Any(), "The Form " + this.FormName + " does not include a control for the field: " + fieldName);
            return fieldMatch.First();
        }

        public XrmFormTab HasTab(string tabName)
        {
            var tabMatch = this.tabs.Where(n => n.Name == tabName);
            if (!tabMatch.Any())
            {
                tabMatch = this.tabs.Where(n => n.DisplayName == tabName);
            }

            Assert.IsTrue(tabMatch.Any(), "The Form " + this.FormName + " does not include a tab named: " + tabName);
            return tabMatch.First();
        }

        #endregion
    }
}