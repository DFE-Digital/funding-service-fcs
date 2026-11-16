// <copyright file="XrmPackageView.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Linq;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework.Legacy;

    // Using statements for Assertions

    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageView
    ///   Description:    Class for handing the Entity Metadata for a single Dynamics CRM View
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class used for handling Dynamics CRM Configuration of a single Dynamics CRM View
    /// </summary>
    public class XrmPackageView
    {
        #region Fields

        /// <summary>
        /// Xml Document holding the View XML
        /// </summary>
        private XmlNode viewXMLField;

        /// <summary>
        /// Xml Document holding the FetchXML
        /// </summary>
        private XmlNode fetchXMLField;

        /// <summary>
        /// Logical name for the entity the view is for
        /// </summary>
        private string entityLogicalName;

        private XrmPackageEntity entity;

        #endregion

        #region Properties

        /// <summary>
        /// Gets the name of the View
        /// </summary>
        public string ViewName { get; private set; }

        /// <summary>
        /// Gets a value indicating whether the view is the QuickFind view
        /// </summary>
        public bool IsQuickFind { get; private set; }

        /// <summary>
        /// Gets a value indicating whether the view is the default view
        /// </summary>
        public bool IsDefault { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string ViewId { get; private set; }

        public string QueryType { get; private set; }

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageView"/> class
        /// </summary>
        /// <param name="viewXmlParam">XmlDocument corresponding to the Xml for the view definition</param>
        /// <param name="entityLogicalName">Logical name for the entity the view is for</param>
        public XrmPackageView(XmlDocument viewXmlParam, XrmPackageEntity entity)
        {
            try
            {
                // Load XML into the Object Properties
                this.entity = entity;
                this.entityLogicalName = entity.LogicalName;
                this.viewXMLField = viewXmlParam;
                var fetchXmlNode = this.viewXMLField.SelectSingleNode("//savedquery/fetchxml");
                if (fetchXmlNode != null)
                {
                    this.fetchXMLField = fetchXmlNode;
                }
                this.ViewName = this.viewXMLField.SelectSingleNode(@"//savedquery/LocalizedNames/LocalizedName[@languagecode=""1033""]").Attributes["description"].Value;
                this.IsQuickFind = XrmXmlHelpers.GetBoolValueFromEntityNode(viewXmlParam, "//savedquery/isquickfindquery");
                this.IsDefault = XrmXmlHelpers.GetBoolValueFromEntityNode(viewXmlParam, "//savedquery/isdefault");
                this.ViewId = XrmXmlHelpers.GetStringValueFromXmlNode(viewXmlParam, "//savedquery/savedqueryid");

                this.QueryType = XrmXmlHelpers.GetStringValueFromXmlNode(viewXmlParam, "//savedquery/querytype");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("An error has occurred: " + ex.InnerException.ToString());
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Verifies whether the View has a column as defined in the parameter. Assertion will fail if the view does not have the column specified
        /// </summary>
        /// <param name="columnName">The logical name of the column in the view</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasColumn(string columnName)
        {
            var columnFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/attribute[@name=\"" + columnName + "\"]");

            if (columnFilters.Count == 0)
            {
                var attribute = this.entity.Attribute(columnName);
                columnFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/attribute[@name=\"" + attribute.LogicalName + "\"]");
            }

            ClassicAssert.IsTrue(columnFilters.Count > 0, "The column: " + columnName + " does not appear in the view: " + this.ViewName);
            return this;
        }

        /// <summary>
        /// Verifies whether the View has a linked column as defined in the parameter. Assertion will fail if the view does not have the column specified
        /// </summary>
        /// <param name="LinkedcolumnName">The logical name of the column in the view</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasLinkedColumn(string linkedColumnName)
        {
            var columnFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/link-entity[@to=\"" + linkedColumnName + "\"]");

            if (columnFilters.Count == 0)
            {
                var attribute = this.entity.Attribute(linkedColumnName);
                columnFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/link-entity[@to=\"" + attribute.LogicalName + "\"]");
            }
            ClassicAssert.IsTrue(columnFilters.Count > 0, "The column: " + linkedColumnName + " does not appear in the view: " + this.ViewName);
            return this;
        }

        /// <summary>
        /// Verifies whether the View has a field is included in the Quick Search fields. Assertion will fail if the view does not have the search field specified
        /// </summary>
        /// <param name="searchFieldName">The logical name of the search field</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasSearchField(string searchFieldName)
        {
            if (this.IsQuickFind == false)
            {
                ClassicAssert.Fail("The selected view is not a Quick Find view");
            }
            else
            {
                var searchFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/filter[@isquickfindfields=\"" + "1" + "\"]/condition[@attribute=\"" + searchFieldName + "\"]");

                if (searchFilters.Count == 0)
                {
                    var attribute = this.entity.Attribute(searchFieldName);
                    searchFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/filter[@isquickfindfields=\"" + "1" + "\"]/condition[@attribute=\"" + attribute.LogicalName + "\"]");
                }

                ClassicAssert.IsTrue(searchFilters.Count > 0, "The field " + searchFieldName + " is not searchable in the Quick Find view");
            }

            return this;
        }

        /// <summary>
        /// Verifies the view contains the filter specified in the parameters. Assertion will fail if the view does not contain the filters
        /// </summary>
        /// <param name="filterFieldName">The logical name of the field to be filtered</param>
        /// <param name="xrmOperator">The operator to be used in the filter</param>
        /// <param name="xrmValue">The value passed to the filter</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasFilter(string filterFieldName, XrmFilterOperator xrmOperator, string xrmValue)
        {
            string xrmOperatorString = xrmOperator.ToDescription();
            int xrmIntValue;
            if (!int.TryParse(xrmValue, out xrmIntValue))
            {
                var attribute = this.entity.Attribute(filterFieldName);
                var o = attribute.OptionSetList.Where(a => a.Value == xrmValue);
                if (o.Any())
                {
                    xrmValue = o.First().Key.ToString();
                }
                else
                {
                    ClassicAssert.Fail("The Value on the field " + filterFieldName + " with " + xrmValue + " does not match");
                }
            }

            var selectFilters = this.fetchXMLField.SelectNodes(".//condition[@attribute=\"" + filterFieldName + "\" and @operator=\"" + xrmOperatorString + "\" and @value=\"" + xrmValue + "\"]");

            if (selectFilters.Count == 0)
            {
                var attribute = this.entity.Attribute(filterFieldName);
                selectFilters = this.fetchXMLField.SelectNodes(".//condition[@attribute=\"" + attribute.LogicalName + "\" and @operator=\"" + xrmOperatorString + "\" and @value=\"" + xrmValue + "\"]");
            }

            ClassicAssert.IsTrue(selectFilters.Count > 0, "The filter on the field " + filterFieldName + " does not match the specified criteria");
            return this;
        }

        /// <summary>
        /// Overloaded: Verifies the view contains the linked filter specified in the parameters. Assertion will fail if the view does not contain the filters
        /// This does not work for optionsets as linked entities may contain non-customisable fields
        /// </summary>
        /// <param name="filterFieldName">The logical name of the field to be filtered</param>
        /// <param name="xrmOperator">The operator to be used in the filter</param>
        /// <param name="xrmValue">The value passed to the filter</param>
        /// <param name="linkedEntity">The defition of the linked entity to search</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasFilter(string filterFieldName, XrmFilterOperator xrmOperator, string xrmValue, XrmPackageEntity linkedEntity)
        {
            string xrmOperatorString = xrmOperator.ToDescription();

            var selectFilters = this.fetchXMLField.SelectNodes(".//condition[@attribute=\"" + filterFieldName + "\" and @operator=\"" + xrmOperatorString + "\" and @value=\"" + xrmValue + "\"]");

            if (selectFilters.Count == 0)
            {
                var attribute = this.entity.Attribute(filterFieldName);
                selectFilters = this.fetchXMLField.SelectNodes(".//condition[@attribute=\"" + attribute.LogicalName + "\" and @operator=\"" + xrmOperatorString + "\" and @value=\"" + xrmValue + "\"]");
            }

            ClassicAssert.IsTrue(selectFilters.Count > 0, "The filter on the field " + filterFieldName + " for the linked entity " + linkedEntity.LogicalName + " does not match the specified criteria");
            return this;
        }

        /// <summary>
        /// Verifies the view contains the sort column specified in the parameters. Assertion will fail if the view is not sorted by the specified column
        /// </summary>
        /// <param name="sortFieldName">The logical name of the field to be sorted</param>
        /// <param name="sortDirection">The sort direction of the sort</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView HasSortColumn(string sortFieldName, XrmSortOrder sortDirection)
        {
            string descending;
            descending = (sortDirection == XrmSortOrder.Ascending) ? "false" : "true";

            var sortFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/order[@attribute=\"" + sortFieldName + "\" and @descending=\"" + descending + "\"]");

            if (sortFilters.Count == 0)
            {
                var attribute = this.entity.Attribute(sortFieldName);
                sortFilters = this.fetchXMLField.SelectNodes("//fetchxml/fetch/entity/order[@attribute=\"" + attribute.LogicalName + "\" and @descending=\"" + descending + "\"]");
            }

            ClassicAssert.IsTrue(sortFilters.Count > 0, "The sort on the field " + sortFieldName + " does not match the specified criteria");
            
            return this;
        }

        /// <summary>
        /// Verifies the view contains the sort column specified in the parameters. Assertion will fail if the view is not sorted by the specified column
        /// </summary>
        /// <param name="sortFieldName">The logical name of the field to be sorted</param>
        /// <param name="sortDirection">The sort direction of the sort</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageView ViewNameEquals(string viewName)
        {
            ClassicAssert.IsTrue(this.ViewName == ViewName, "The requsted View Name " + viewName + " does not match the actual view name : " + this.ViewName);
            return this;
        }

        #endregion
    }
}