namespace SFA.FCT.Xrm.TestFramework
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework.Legacy;

    /// <summary>
    /// Class used for handling configuration of a Dynamics CRM Dashboard
    /// </summary>
    public class XrmPackageDashboard
    {
        #region Fields

        private List<XrmPackageDashboardItem> _items;
        private string _dashboardId;
        private bool _isSystemDefault;

        #endregion

        #region Constructors

        public XrmPackageDashboard(XmlNode dashboardXml)
        {
            var dashboardNameNode =
                dashboardXml.SelectSingleNode(@"/Dashboard/LocalizedNames/LocalizedName[@languagecode=""1033""]");
            if (dashboardNameNode != null)
            {
                if (dashboardNameNode.Attributes != null)
                {
                    Name = dashboardNameNode.Attributes["description"].Value;
                }
            }

            var dashboardIdNode = dashboardXml.SelectSingleNode(@"/Dashboard/FormId");
            if (dashboardIdNode != null)
            {
                _dashboardId = dashboardIdNode.InnerText.ToUpperInvariant().Replace("{", "").Replace("}", "");
            }

            var dashboardDefaultNode = dashboardXml.SelectSingleNode(@"/Dashboard/IsDefault");
            if (dashboardIdNode != null)
            {
                _isSystemDefault = XrmXmlHelpers.GetBoolValueFromEntityNode(dashboardXml,
                    @"/Dashboard/IsDefault");
            }

            List<XrmPackageDashboardItem> dashboardItems = new List<XrmPackageDashboardItem>();

            // Loop through XML Nodes identified as having controls bound to a data field name
            foreach (XmlNode c in dashboardXml.SelectNodes("//control"))
            {
                XmlNode parameterNode = c.SelectSingleNode("./parameters");

                if (parameterNode != null)
                {
                    // TODO: Add addtional functionality for recognising Charts, IFrames and Web Resources
                    if (parameterNode["ChartGridMode"] != null && parameterNode["ChartGridMode"].InnerText == "Grid")
                    {
                        dashboardItems.Add(new XrmPackageDashboardItem(parameterNode["ViewId"].InnerText,
                            string.Empty, bool.Parse(parameterNode["EnableQuickFind"].InnerText), XrmDashboardItemType.View));
                    }
                }

                _items = dashboardItems;
            }
        }

        #endregion

        #region Properties

        public string Name { get; private set; }

        #endregion

        #region Methods

        public XrmPackageDashboard IsSystemDefault(bool isDefault)
        {
            ClassicAssert.AreEqual(isDefault, _isSystemDefault, "Default status of the dashboard is incorrect");
            return this;
        }

        public XrmPackageDashboard HasGridWithView(string viewId, bool quickFindEnabled)
        {
            var gridMatch = _items.Where(i => i.Type == XrmDashboardItemType.View && i.ViewId == viewId);

            ClassicAssert.IsTrue(gridMatch.Any(), "The view {0} is not on the dashboard", viewId);
            ClassicAssert.AreEqual(gridMatch.First().QuickFindEnabled, quickFindEnabled,
                "The QuickView status of the Dashboard Item was incorrect");
            return this;
        }

        #endregion
    }

    public class XrmPackageDashboardItem
    {

        #region Fields

        private string _visualisationId;
        internal string ViewId;

        public XrmPackageDashboardItem(string viewId, string visualisationId, bool quickFindEnabled,
            XrmDashboardItemType type)
        {
            ViewId = viewId;
            _visualisationId = visualisationId;
            QuickFindEnabled = quickFindEnabled;
            Type = type;
        }


        #endregion

        #region

        public bool QuickFindEnabled { get; private set; }
        public XrmDashboardItemType Type { get; private set; }

        #endregion
    }
}

